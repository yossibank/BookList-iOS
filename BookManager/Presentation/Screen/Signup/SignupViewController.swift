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

    private let mainStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 32
    )

    private let userIconStackView: UIStackView = .init(
        style: .horizontalStyle,
        spacing: 16
    )

    private let userIconImageView: UIImageView = .init(
        style: .iconStyle
    )

    private let spacerView: UIView = .init()

    private let userIconSelectButton: UIButton = .init(
        title: "チャット画像選択",
        backgroundColor: .black,
        style: .fontBoldStyle
    )

    private let userNameStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 4
    )

    private let userNameTextField: UITextField = .init(
        placeholder: "ニックネーム",
        keyboardType: .default,
        style: .borderBottomStyle
    )

    private let emailStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 4
    )

    private let emailTextField: UITextField = .init(
        placeholder: Resources.Strings.General.mailAddress,
        keyboardType: .emailAddress,
        style: .borderBottomStyle
    )

    private let passwordStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 4
    )

    private let passwordTextField: UITextField = .init(
        placeholder: Resources.Strings.General.password,
        style: .securePassword
    )

    private let passwordConfirmationStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 4
    )

    private let passwordConfirmationTextField: UITextField = .init(
        placeholder: Resources.Strings.General.password,
        style: .securePassword
    )

    private let secureStackView: UIStackView = .init(
        style: .horizontalStyle,
        spacing: 8
    )

    private let secureButton: UIButton = .init(
        image: Resources.Images.App.nonCheck
    )

    private let secureLabel: UILabel = .init(
        text: Resources.Strings.Account.showPassword,
        style:  .fontBoldStyle
    )

    private let buttonStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 16
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

            [passwordTextField, passwordConfirmationTextField].forEach {
                $0?.isSecureTextEntry = !isSecureCheck
            }
        }
    }
}

// MARK: - override methods

extension SignupViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupTextField()
        setupButton()
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

private extension SignupViewController {

    func setupView() {
        view.backgroundColor = .white

        userNameStackView.addArrangedSubview(userNameTextField)
        emailStackView.addArrangedSubview(emailTextField)
        passwordStackView.addArrangedSubview(passwordTextField)
        passwordConfirmationStackView.addArrangedSubview(passwordConfirmationTextField)

        let userIconStackViewList = [
            userIconImageView,
            spacerView,
            userIconSelectButton
        ]

        userIconStackViewList.forEach {
            userIconStackView.addArrangedSubview($0)
        }

        let secureStackViewList = [
            secureButton,
            secureLabel
        ]

        secureStackViewList.forEach {
            secureStackView.addArrangedSubview($0)
        }

        let buttonStackViewList = [
            signupButton,
            loginButton
        ]

        buttonStackViewList.forEach {
            buttonStackView.addArrangedSubview($0)
        }

        let stackViewList = [
            userIconStackView,
            userNameStackView,
            emailStackView,
            passwordStackView,
            passwordConfirmationStackView,
            secureStackView,
            buttonStackView
        ]

        stackViewList.forEach {
            mainStackView.addArrangedSubview($0)
        }

        view.addSubview(mainStackView)
        view.addSubview(loadingIndicator)
    }

    func setupLayout() {
        mainStackView.layout {
            $0.centerY == view.centerYAnchor
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 48)
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -48)
        }

        loadingIndicator.layout {
            $0.centerX == view.centerXAnchor
            $0.centerY == view.centerYAnchor
        }

        userIconImageView.layout {
            $0.widthConstant == 60
            $0.heightConstant == 60
        }

        spacerView.layout {
            $0.widthConstant == 40
        }

        userIconSelectButton.layout {
            $0.heightConstant == 60
        }

        secureButton.layout {
            $0.widthConstant == 15
            $0.heightConstant == 15
        }

        [userNameTextField,
         emailTextField,
         passwordTextField,
         passwordConfirmationTextField
        ].forEach {
            $0.layout {
                $0.heightConstant == 30
            }
        }

        [loginButton, signupButton].forEach {
            $0.layout {
                $0.heightConstant == 40
            }
        }
    }

    func setupTextField() {
        let textFields = [
            userNameTextField,
            emailTextField,
            passwordTextField,
            passwordConfirmationTextField
        ]

        textFields.forEach { $0.delegate = self }

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
        userIconSelectButton.tapPublisher
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
            textFields[currentTextFieldIndex + 1].becomeFirstResponder()
        }

        return true
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
