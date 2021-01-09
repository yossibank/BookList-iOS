import UIKit
import RxSwift
import RxCocoa

final class SignupViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var secureTextChangeButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var keyboardNotifier: KeyboardNotifier = KeyboardNotifier()

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: SignupViewModel!
    private var isSecureCheck: Bool = true

    static func createInstance(viewModel: SignupViewModel) -> SignupViewController {
        let instance = SignupViewController.instantiateInitialViewController()
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

extension SignupViewController {

    private func setupTextField() {
        [emailTextField, passwordTextField, passwordConfirmationTextField]
            .forEach { $0?.delegate = self }
    }

    private func setupButton() {
        secureTextChangeButton.addTarget(
            self,
            action: #selector(secureTextChange),
            for: .touchUpInside
        )

        signupButton.addTarget(
            self,
            action: #selector(showHomeScreen),
            for: .touchUpInside
        )

        loginButton.addTarget(
            self,
            action: #selector(showLoginScreen),
            for: .touchUpInside
        )
    }

    @objc private func secureTextChange(_ sender: UIButton) {
        let secureImage = isSecureCheck
            ? Resources.Images.Account.checkInBox
            : Resources.Images.Account.checkOffBox
        sender.setImage(secureImage, for: .normal)

        [passwordTextField, passwordConfirmationTextField].forEach {
            $0?.isSecureTextEntry = isSecureCheck ? false : true
        }
        isSecureCheck = !isSecureCheck
    }

    @objc private func showHomeScreen(_ sender: UIButton) {
        viewModel.signup(
            email: emailTextField.text ?? "",
            password: passwordTextField.text ?? ""
        )
    }

    @objc private func showLoginScreen(_ sender: UIButton) {
        if presentingViewController is LoginViewController {
            self.dismiss(animated: true)
        } else {
            router.present(.login, from: self, isModalInPresentation: false)
        }
    }
}

extension SignupViewController {

    private func bindValue() {
        Observable
            .combineLatest(
                emailTextField.rx.text.orEmpty.map { $0.isEmpty },
                passwordTextField.rx.text.orEmpty.map { $0.isEmpty },
                passwordConfirmationTextField.rx.text.orEmpty.map { $0.isEmpty })
            .map { isEmailEmpty, isPasswordEmpty, isPasswordConfirmationEmpty -> Bool in
                !(isEmailEmpty || isPasswordEmpty || isPasswordConfirmationEmpty)
            }
            .subscribe(onNext: { [weak self] isEnabled in
                let backgroundColor: UIColor = isEnabled ? .blue : .lightGray
                self?.signupButton.backgroundColor = backgroundColor
                self?.signupButton.isEnabled = isEnabled
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

                case .success(let response):
                    dump(response)
                    print("success.")

                case .failure(let error):
                    if let error = error as? APIError {
                        dump(error.description())
                    }
                    print("failure.")
                }
            }).disposed(by: disposeBag)

        viewModel.loading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] loading in
                guard let self = self else { return }

                loading ? self.loadingIndicator.startAnimating() : self.loadingIndicator.stopAnimating()
            }).disposed(by: disposeBag)
    }
}

extension SignupViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if emailTextField == textField {
            passwordTextField.becomeFirstResponder()
        } else if passwordTextField == textField {
            passwordConfirmationTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension SignupViewController: KeyboardDelegate {

    func keyboardPresent(_ height: CGFloat) {
        let displayHeight = self.view.frame.height - height
        let signupButtonOffsetY = signupButton.convert(signupButton.frame, to: stackView).minY
        let bottomOffsetY = signupButtonOffsetY - displayHeight
        view.frame.origin.y == 0 ? (view.frame.origin.y -= bottomOffsetY) : ()
    }

    func keyboardDismiss(_ height: CGFloat) {
        view.frame.origin.y != 0 ? (view.frame.origin.y = 0) : ()
    }
}
