import Combine
import CombineCocoa
import UIKit
import Utility

extension LoginViewController: VCInjectable {
    typealias R = LoginRouting
    typealias VM = LoginViewModel
}

// MARK: - properties

final class LoginViewController: UIViewController {
    var routing: R! { didSet { self.routing.viewController = self } }
    var viewModel: VM!
    var keyboardNotifier: KeyboardNotifier = KeyboardNotifier()

    private var cancellables: Set<AnyCancellable> = []
    private var isSecureCheck: Bool = false {
        didSet {
            let image = isSecureCheck
                ? Resources.Images.App.check
                : Resources.Images.App.nonCheck

            secureButton.setImage(image, for: .normal)

            passwordTextField.isSecureTextEntry = !isSecureCheck
        }
    }

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var secureButton: UIButton!
    @IBOutlet weak var validateEmailLabel: UILabel!
    @IBOutlet weak var validatePasswordLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
}

// MARK: - override methods

extension LoginViewController {

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

private extension LoginViewController {

    func setupTextField() {
        [emailTextField, passwordTextField].forEach {
            $0?.delegate = self
        }

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
    }

    func setupButton() {
        secureButton.tapPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.isSecureCheck = !self.isSecureCheck
            }
            .store(in: &cancellables)

        signupButton.tapPublisher
            .sink { [weak self] _ in
                self?.routing.showSignupScreen()
            }
            .store(in: &cancellables)

        loginButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.login()
            }
            .store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .standby:
                    self?.loadingIndicator.stopAnimating()

                case .loading:
                    self?.loadingIndicator.startAnimating()

                case .done:
                    self?.loadingIndicator.stopAnimating()
                    self?.routing.showHomeScreen()

                case .failed:
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Delegate

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields = [emailTextField, passwordTextField]

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

// MARK: - Protocol

extension LoginViewController: AnalyticsConfiguration {

    var screenName: AnalyticsScreenName? {
        .login
    }
}
