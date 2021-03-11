import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var secureButton: UIButton!
    @IBOutlet weak var validateEmailLabel: UILabel!
    @IBOutlet weak var validatePasswordLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    var keyboardNotifier: KeyboardNotifier = KeyboardNotifier()

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: LoginViewModel!
    private var isSecureCheck: Bool = true

    static func createInstance(viewModel: LoginViewModel) -> LoginViewController {
        let instance = LoginViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupButton()
        bindValue()
        bindViewModel()
        listenerKeyboard(keyboardNotifier: keyboardNotifier)
        sendScreenView()
    }
}

extension LoginViewController {

    private func setupTextField() {
        [emailTextField, passwordTextField].forEach {
            $0?.delegate = self
        }
    }

    private func setupButton() {
        secureButton.rx.tap.subscribe { [weak self] _ in
            self?.secureButtonTapped()
        }.disposed(by: disposeBag)

        loginButton.rx.tap.subscribe { [weak self] _ in
            self?.loginButtonTapped()
        }.disposed(by: disposeBag)
        
        signupButton.rx.tap.subscribe { [weak self] _ in
            self?.signupButtonTapped()
        }.disposed(by: disposeBag)
    }

    private func secureButtonTapped() {
        let secureImage = isSecureCheck
            ? Resources.Images.Account.checkInBox
            : Resources.Images.Account.checkOffBox
        secureButton.setImage(secureImage, for: .normal)

        passwordTextField.isSecureTextEntry = isSecureCheck ? false : true
        isSecureCheck = !isSecureCheck
    }

    private func loginButtonTapped() {
        if let email = emailTextField.text,
           let password = passwordTextField.text
        {
            viewModel.login(
                email: email,
                password: password
            )
        }
    }

    private func signupButtonTapped() {
        if presentingViewController is SignupViewController {
            self.dismiss(animated: true)
        } else {
            router.present(
                .signup,
                from: self,
                wrapInNavigationController: false
            )
        }
    }
}

extension LoginViewController {

    private func bindValue() {

        emailTextField.rx.text
            .validate(EmailValidator.self)
            .map { validate in
                validate.errorDescription
            }
            .skip(2)
            .bind(to: validateEmailLabel.rx.text)
            .disposed(by: disposeBag)

        passwordTextField.rx.text
            .validate(PasswordValidator.self)
            .map { validate in
                validate.errorDescription
            }
            .skip(2)
            .bind(to: validatePasswordLabel.rx.text)
            .disposed(by: disposeBag)

        Observable
            .combineLatest(
                emailTextField.rx.text.orEmpty.map { $0.isEmpty },
                passwordTextField.rx.text.orEmpty.map { $0.isEmpty })
            .map { isEmailEmpty, isPasswordEmpty in
                return !(isEmailEmpty || isPasswordEmpty)
            }
            .subscribe(onNext: { [weak self] isEnabled in
                let isEnabled = isEnabled
                    && self?.validateEmailLabel.text == nil
                    && self?.validatePasswordLabel.text == nil

                self?.loginButton.alpha = isEnabled ? 1.0 : 0.5
                self?.loginButton.isEnabled = isEnabled
            })
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {

        viewModel.result
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] result in
                guard let self = self,
                      let result = result else { return }

                switch result {

                case .success:
                    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                    window?.rootViewController = self.router.initialWindow(.home, type: .navigation)

                case .failure(let error):
                    if let error = error as? APIError {
                        dump(error.description())
                    }
                    self.showError(
                        title: Resources.Strings.General.error,
                        message: Resources.Strings.Alert.failedLogin
                    )
                }
            })
            .disposed(by: disposeBag)

        viewModel.loading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] loading in
                guard let self = self else { return }

                loading
                    ? self.loadingIndicator.startAnimating()
                    : self.loadingIndicator.stopAnimating()
            })
            .disposed(by: disposeBag)
    }
}

extension LoginViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField == textField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension LoginViewController: KeyboardDelegate {

    func keyboardPresent(_ height: CGFloat) {
        let displayHeight = view.frame.height - height
        let bottomOffsetY = stackView.convert(
            loginButton.frame, to: self.view
        ).maxY + 20 - displayHeight

        view.frame.origin.y == 0 ? (view.frame.origin.y -= bottomOffsetY) : ()
    }

    func keyboardDismiss(_ height: CGFloat) {
        view.frame.origin.y != 0 ? (view.frame.origin.y = 0) : ()
    }
}

extension LoginViewController: AnalyticsConfiguration {

    var screenName: AnalyticsScreenName? {
        .login
    }
}
