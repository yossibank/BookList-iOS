import UIKit
import RxSwift
import RxCocoa

final class SignupViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var userIconImageView: UIImageView!
    @IBOutlet weak var userIconButton: IBDesignableButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var secureButton: UIButton!
    @IBOutlet weak var validateUserNameLabel: UILabel!
    @IBOutlet weak var validateEmailLabel: UILabel!
    @IBOutlet weak var validatePasswordLabel: UILabel!
    @IBOutlet weak var validatePasswordConfirmationLabel: UILabel!
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
        bindValue()
        bindViewModel()
        listenerKeyboard(keyboardNotifier: keyboardNotifier)
        sendScreenView()
    }
}

extension SignupViewController {

    private func setupTextField() {
        [
            userNameTextField, emailTextField,
            passwordTextField, passwordConfirmationTextField
        ].forEach {
            $0?.delegate = self
        }
    }

    private func setupButton() {
        userIconButton.rx.tap.subscribe { [weak self] _ in
            self?.userIconButtonTapped()
        }.disposed(by: disposeBag)

        secureButton.rx.tap.subscribe { [weak self] _ in
            self?.secureButtonTapped()
        }.disposed(by: disposeBag)

        signupButton.rx.tap.subscribe { [weak self] _ in
            self?.signupButtonTapped()
        }.disposed(by: disposeBag)

        loginButton.rx.tap.subscribe { [weak self] _ in
            self?.loginButtonTapped()
        }.disposed(by: disposeBag)
    }

    private func userIconButtonTapped() {
        let photoLibrary = UIImagePickerController.SourceType.photoLibrary

        if UIImagePickerController.isSourceTypeAvailable(photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }

    private func secureButtonTapped() {
        let secureImage = isSecureCheck
            ? Resources.Images.Account.checkInBox
            : Resources.Images.Account.checkOffBox
        secureButton.setImage(secureImage, for: .normal)

        [passwordTextField, passwordConfirmationTextField].forEach {
            $0?.isSecureTextEntry = isSecureCheck ? false : true
        }
        isSecureCheck = !isSecureCheck
    }

    private func signupButtonTapped() {
        if let email = emailTextField.text,
           let password = passwordTextField.text
        {
            viewModel.signup(
                email: email,
                password: password
            )
        }
    }

    private func loginButtonTapped() {
        if presentingViewController is LoginViewController {
            dismiss(animated: true)
        } else {
            router.present(
                .login,
                from: self
            )
        }
    }
}

extension SignupViewController {

    private func bindValue() {

        userNameTextField.rx.text
            .validate(NameValidator.self)
            .map { validate in
                validate.errorDescription
            }
            .skip(2)
            .bind(to: validateUserNameLabel.rx.text)
            .disposed(by: disposeBag)

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
                passwordTextField.rx.text.orEmpty.map { $0 },
                passwordConfirmationTextField.rx.text.map { $0 })
            .map { passwordText, passwordConfirmationText in
                if passwordText == passwordConfirmationText {
                    return nil
                }
                return Resources.Strings.Validator.notMatchingPassword
            }
            .subscribe(onNext: { [weak self] text in
                self?.validatePasswordConfirmationLabel.text = text
            })
            .disposed(by: disposeBag)

        Observable
            .combineLatest(
                emailTextField.rx.text.orEmpty.map { $0.isEmpty },
                passwordTextField.rx.text.orEmpty.map { $0.isEmpty },
                passwordConfirmationTextField.rx.text.orEmpty.map { $0.isEmpty })
            .map { isEmailEmpty, isPasswordEmpty, isPasswordConfirmationEmpty in
                !(isEmailEmpty ||  isPasswordEmpty || isPasswordConfirmationEmpty)
            }
            .subscribe(onNext: { [weak self] isEnabled in
                let isEnabled = isEnabled
                    && self?.validateEmailLabel.text == nil
                    && self?.validatePasswordLabel.text == nil
                    && self?.validatePasswordConfirmationLabel.text == nil

                self?.signupButton.alpha = isEnabled ? 1.0 : 0.5
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
                    guard
                        let name = self.userNameTextField.text,
                        let email = self.emailTextField.text,
                        let password = self.passwordTextField.text,
                        let uploadImage = self.userIconImageView.image?.jpegData(compressionQuality: 0.5)
                    else {
                        return
                    }

                    self.viewModel.saveUserIconImage(
                        path: email,
                        uploadImage: uploadImage
                    )

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.viewModel.fetchDownloadUrlString(path: email) { [weak self] urlString in
                            guard let self = self else { return }

                            let user = FirestoreUser(
                                id: response.result.id,
                                name: name,
                                email: email,
                                imageUrl: urlString
                            )

                            self.viewModel.createUserForFirebase(
                                email: email,
                                password: password,
                                user: user
                            )
                        }
                    }

                    let window = UIApplication.shared.windows.first { $0.isKeyWindow }
                    window?.rootViewController = self.router.initialWindow(.home, type: .navigation)

                case .failure(let error):
                    if let error = error as? APIError {
                        dump(error.description())
                    }
                    self.showError(
                        title: Resources.Strings.General.error,
                        message: Resources.Strings.Alert.failedSignup
                    )
                }
            }).disposed(by: disposeBag)

        viewModel.loading
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] loading in
                guard let self = self else { return }

                loading
                    ? self.loadingIndicator.startAnimating()
                    : self.loadingIndicator.stopAnimating()
            }).disposed(by: disposeBag)
    }
}

extension SignupViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if userNameTextField == textField {
            emailTextField.becomeFirstResponder()
        } else if emailTextField == textField {
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
        let displayHeight = view.frame.height - height
        let bottomOffsetY = stackView.convert(
            signupButton.frame,
            to: self.view
        ).maxY + 20 - displayHeight

        view.frame.origin.y == 0 ? (view.frame.origin.y -= bottomOffsetY) : ()
    }

    func keyboardDismiss(_ height: CGFloat) {
        view.frame.origin.y != 0 ? (view.frame.origin.y = 0) : ()
    }
}

extension SignupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[.editedImage] as? UIImage {
            userIconImageView.image = image
        } else if let originalImage = info[.originalImage] as? UIImage {
            userIconImageView.image = originalImage
        }
        self.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}

extension SignupViewController: AnalyticsConfiguration {
    var screenName: AnalyticsScreenName? { .signup }
}
