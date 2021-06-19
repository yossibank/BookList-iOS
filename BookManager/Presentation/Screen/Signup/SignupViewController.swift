import Combine
import CombineCocoa
import UIKit
import Utility

extension SignupViewController: VCInjectable {
    typealias R = SignupRouting
    typealias VM = SignupViewModel
}

// MARK: - properties

final class SignupViewController: UIViewController {
    var routing: R! { didSet { self.routing.viewController = self } }
    var viewModel: VM!
    var keyboardNotifier: KeyboardNotifier = KeyboardNotifier()

    private var cancellables: Set<AnyCancellable> = []
    private var isSecureCheck: Bool = false {
        didSet {
            let image = isSecureCheck
                ? Resources.Images.Account.checkInBox
                : Resources.Images.Account.checkOffBox

            secureButton.setImage(image, for: .normal)

            [passwordTextField, passwordConfirmationTextField].forEach {
                $0?.isSecureTextEntry = !isSecureCheck
            }
        }
    }

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
}

// MARK: - override methods

extension SignupViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        listenerKeyboard(keyboardNotifier: keyboardNotifier)
        setupTextField()
        setupButton()
        bindViewModel()
        sendScreenView()
    }

    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {
        view.endEditing(true)
    }
}

// MARK: - private methods

private extension SignupViewController {

    func setupTextField() {
        let textFields = [
            userNameTextField,
            emailTextField,
            passwordTextField,
            passwordConfirmationTextField
        ]

        textFields.forEach { $0?.delegate = self }

        userNameTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.userName, on: viewModel)
            .store(in: &cancellables)

        emailTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.email, on: viewModel)
            .store(in: &cancellables)

        passwordTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.password, on: viewModel)
            .store(in: &cancellables)

        passwordConfirmationTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.passwordConfirmation, on: viewModel)
            .store(in: &cancellables)
    }

    func setupButton() {
        userIconButton.tapPublisher
            .sink { [weak self] in
                let photoLibrary = UIImagePickerController.SourceType.photoLibrary

                if UIImagePickerController.isSourceTypeAvailable(photoLibrary) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.allowsEditing = true
                    picker.delegate = self
                    self?.present(picker, animated: true)
                }
            }
            .store(in: &cancellables)

        secureButton.tapPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                self.isSecureCheck = !self.isSecureCheck
            }
            .store(in: &cancellables)

        loginButton.tapPublisher
            .sink { [weak self] in
                self?.routing.showLoginScreen()
            }
            .store(in: &cancellables)

        signupButton.tapPublisher
            .sink { [weak self] in
                self?.viewModel.signup()
            }
            .store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.$state
            .sink { [weak self] state in
                switch state {
                case .standby:
                    self?.loadingIndicator.stopAnimating()

                case .loading:
                    self?.loadingIndicator.startAnimating()

                case let .done(entities):
                    self?.loadingIndicator.stopAnimating()
                    self?.routing.showHomeScreen()

                case let .failed(error):
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
}

extension SignupViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields = [
            userNameTextField,
            emailTextField,
            passwordTextField,
            passwordConfirmationTextField
        ]

        guard
            let currentTextFieldIndex = textFields.firstIndex(of: textField)
        else {
            return false
        }

        if currentTextFieldIndex + 1 == textFields.endIndex {
            textField.resignFirstResponder()
        } else {
            textFields[currentTextFieldIndex + 1]?.becomeFirstResponder()
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
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.editedImage] as? UIImage {
            userIconImageView.image = image
        } else if let originalImage = info[.originalImage] as? UIImage {
            userIconImageView.image = originalImage
        }

        routing.dismiss()
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        routing.dismiss()
    }
}

extension SignupViewController: AnalyticsConfiguration {

    var screenName: AnalyticsScreenName? {
        .signup
    }
}
