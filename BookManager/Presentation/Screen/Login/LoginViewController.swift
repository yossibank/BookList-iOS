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

    private let stackView = UIStackView(
        style: .verticalStyle,
        spacing: 32
    )

    private let emailTextField: UITextField = .init(
        placeholder: Resources.Strings.General.mailAddress,
        keyboardType: .emailAddress,
        style: .borderBottomStyle
    )

    private let passwordTextField: UITextField = .init(
        placeholder: Resources.Strings.General.password,
        style: .securePassword
    )

    private let secureStackView: UIStackView = .init(
        style: .horizontalStyle,
        spacing: 0
    )

    private let secureButton: UIButton = .init(
        image: Resources.Images.App.nonCheck
    )

    private let secureLabel: UILabel = .init(
        text: Resources.Strings.Account.showPassword,
        style:  .fontBoldStyle
    )

    private let loginButton: UIButton = .init(
        title: Resources.Strings.Account.login,
        backgroundColor: .systemGreen,
        style: .fontBoldStyle
    )

    private let signupButton: UIButton = .init(
        title: Resources.Strings.Account.createAccount,
        backgroundColor: .systemBlue,
        style: .fontBoldStyle
    )

    private let loadingIndicator: UIActivityIndicatorView = .init(
        style: .largeStyle
    )

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
}

// MARK: - override methods

extension LoginViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        listenerKeyboard(keyboardNotifier: keyboardNotifier)
        setupView()
        setupTextField()
        setupButton()
        setupLayout()
        bindViewModel()
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

    func setupView() {
        view.backgroundColor = .white

        let secureStackViewList = [
            secureButton,
            secureLabel
        ]

        secureStackViewList.forEach {
            secureStackView.addArrangedSubview($0)
        }

        let stackViewList = [
            emailTextField,
            passwordTextField,
            secureStackView,
            loginButton,
            signupButton
        ]

        stackViewList.forEach {
            stackView.addArrangedSubview($0)
        }

        view.addSubview(loadingIndicator)
        view.addSubview(stackView)
    }

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

    func setupLayout() {
        stackView.layout {
            $0.centerY == view.centerYAnchor
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 48)
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -48)
        }

        self.loadingIndicator.layout {
            $0.centerX == view.centerXAnchor
            $0.centerY == view.centerYAnchor
        }

        [emailTextField, passwordTextField].forEach {
            $0.layout {
                $0.heightConstant == 30
            }
        }

        [loginButton, signupButton].forEach {
            $0.layout {
                $0.heightConstant == 50
            }
        }
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
                    self?.routing.showRootScreen()

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
            textFields[currentTextFieldIndex + 1].becomeFirstResponder()
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
