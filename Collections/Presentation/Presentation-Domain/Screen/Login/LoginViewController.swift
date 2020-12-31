import UIKit

final class LoginViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var secureTextChangeButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!

    var keyboardNotifier: KeyboardNotifier = KeyboardNotifier()

    private let router: RouterProtocol = Router()

    private var isSecureCheck: Bool = true

    static func createInstance() -> LoginViewController {
        LoginViewController.instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupButton()
        listenerKeyboard(keyboardNotifier: keyboardNotifier)
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

    }

    @objc private func showSignupScreen(_ sender: UIButton) {
        if presentingViewController is SignupViewController {
            self.dismiss(animated: true)
        } else {
            router.present(.signup, from: self, isModalInPresentation: false)
        }
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
        let loginButtonContentOffsetY = loginButton.convert(loginButton.frame, to: stackView).maxY
        let bottomOffsetY = loginButtonContentOffsetY - displayHeight + 60
        view.frame.origin.y == 0 ? (view.frame.origin.y -= bottomOffsetY) : ()
    }

    func keyboardDismiss(_ height: CGFloat) {
        view.frame.origin.y != 0 ? (view.frame.origin.y = 0) : ()
    }
}
