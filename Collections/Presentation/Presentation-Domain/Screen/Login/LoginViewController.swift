import UIKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var secureTextChangeButton: UIButton!
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
        listenerKeyboard(keyboardNotifier: keyboardNotifier)
        bindValue()
        bindViewModel()
    }
}

extension LoginViewController {

    private func setupTextField() {
        [emailTextField, passwordTextField].forEach {
            $0?.delegate = self
        }
    }

    private func setupButton() {
        secureTextChangeButton.addTarget(
            self,
            action: #selector(secureTextChange),
            for: .touchUpInside
        )

        loginButton.addTarget(
            self,
            action: #selector(showHomeScreen),
            for: .touchUpInside
        )

        signupButton.addTarget(
            self,
            action: #selector(showSignupScreen),
            for: .touchUpInside
        )
    }

    @objc private func secureTextChange(_ sender: UIButton) {
        let secureImage = isSecureCheck
            ? Resources.Images.Account.checkInBox
            : Resources.Images.Account.checkOffBox
        sender.setImage(secureImage, for: .normal)

        passwordTextField.isSecureTextEntry = isSecureCheck ? false : true
        isSecureCheck = !isSecureCheck
    }

    @objc private func showHomeScreen(_ sender: UIButton) {
        viewModel.login(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }

    @objc private func showSignupScreen(_ sender: UIButton) {
        if presentingViewController is SignupViewController {
            self.dismiss(animated: true)
        } else {
            router.present(.signup, from: self, isModalInPresentation: false)
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
    }

    private func bindViewModel() {
        viewModel.result
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] result in
                guard let self = self,
                      let result = result else { return }

                switch result {

                case .success(let response):
                    dump(response)
                    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                    window?.rootViewController = self.router.initialWindow(.home, type: .navigation)

                case .failure(let error):
                    if let error = error as? APIError {
                        dump(error)
                    }
                    self.showError(
                        title: Resources.Strings.General.error,
                        message: Resources.Strings.App.failedLogin
                    )
                }
            })
            .disposed(by: disposeBag)

        viewModel.loading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] loading in
                guard let self = self else { return }

                loading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
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
        let displayHeight = self.view.frame.height - height
        let bottomOffsetY = stackView.convert(
            loginButton.frame, to: self.view
        ).maxY + 20 - displayHeight

        view.frame.origin.y == 0 ? (view.frame.origin.y -= bottomOffsetY) : ()
    }

    func keyboardDismiss(_ height: CGFloat) {
        view.frame.origin.y != 0 ? (view.frame.origin.y = 0) : ()
    }
}
