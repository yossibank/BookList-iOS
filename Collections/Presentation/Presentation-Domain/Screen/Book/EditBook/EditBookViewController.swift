import UIKit
import RxSwift
import RxCocoa

final class EditBookViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var imageSelectButton: UIButton!
    @IBOutlet weak var takingPictureButton: UIButton!
    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var bookPriceTextField: UITextField!
    @IBOutlet weak var bookPurchaseDateTextField: UITextField!
    @IBOutlet weak var validateTitleLabel: UILabel!
    @IBOutlet weak var validatePriceLabel: UILabel!

    var keyboardNotifier: KeyboardNotifier = KeyboardNotifier()

    private let disposeBag: DisposeBag = DisposeBag()

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: view.frame.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDoneButton))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        return toolbar
    }()

    static func createInstance() -> EditBookViewController {
        EditBookViewController.instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTextField()
        setupButton()
        listenerKeyboard(keyboardNotifier: keyboardNotifier)
        bindValue()
    }
}

extension EditBookViewController {

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Resources.Strings.Navigation.done,
            style: .done,
            target: self,
            action: #selector(tappedEditBookButton)
        )
    }

    private func setupTextField() {
        bookPurchaseDateTextField.inputAccessoryView = toolbar
        bookPurchaseDateTextField.inputView = UIDatePicker.purchaseDatePicker

        [bookTitleTextField, bookPriceTextField, bookPurchaseDateTextField]
            .forEach { $0?.delegate = self }
    }

    private func setupButton() {
        imageSelectButton.addTarget(
            self,
            action: #selector(setupPhotoLibrary),
            for: .touchUpInside
        )

        takingPictureButton.addTarget(
            self,
            action: #selector(setupLaunchCamera),
            for: .touchUpInside
        )
    }

    @objc private  func tappedEditBookButton(_ sender: UIButton) {
        
    }

    @objc private func tappedDoneButton(_ sender: UIButton) {
        bookPurchaseDateTextField.text = DateFormatter.convertToYearAndMonth(UIDatePicker.purchaseDatePicker.date)
        bookPurchaseDateTextField.endEditing(true)
    }

    @objc private func setupPhotoLibrary(_ sender: UIButton) {
        let photoLibrary = UIImagePickerController.SourceType.photoLibrary

        if UIImagePickerController.isSourceTypeAvailable(photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }

    @objc private func setupLaunchCamera(_ sender: UIButton) {
        let camera = UIImagePickerController.SourceType.camera

        if UIImagePickerController.isSourceTypeAvailable(camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }
}

extension EditBookViewController {

    private func bindValue() {
        bookTitleTextField.rx.text
            .validate(TitleValidator.self)
            .map { validate in
                validate.errorDescription
            }
            .skip(2)
            .bind(to: validateTitleLabel.rx.text)
            .disposed(by: disposeBag)

        bookPriceTextField.rx.text
            .validate(NumberValidator.self)
            .map { validate in
                validate.errorDescription
            }
            .skip(2)
            .bind(to: validatePriceLabel.rx.text)
            .disposed(by: disposeBag)

        Observable
            .combineLatest(
                bookTitleTextField.rx.text.orEmpty.map { $0.isEmpty },
                bookPriceTextField.rx.text.orEmpty.map { $0.isEmpty },
                bookPurchaseDateTextField.rx.text.orEmpty.map { $0.isEmpty })
            .map { isbookTitleEmpty, isBookPriceEmpty, isBookPurchaseDateEmpty in
                !(isbookTitleEmpty || isBookPriceEmpty || isBookPurchaseDateEmpty)
            }
            .subscribe(onNext: { [weak self] isEnabled in
                self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
            })
            .disposed(by: disposeBag)
    }
}

extension EditBookViewController: UITextFieldDelegate {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if bookTitleTextField == textField {
            bookPriceTextField.becomeFirstResponder()
        } else if bookPriceTextField == textField {
            bookPurchaseDateTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}

extension EditBookViewController: KeyboardDelegate {

    func keyboardPresent(_ height: CGFloat) {
        let displayHeihgt = view.frame.height - height
        let bottomOffsetY = stackView.convert(
            bookPurchaseDateTextField.frame,
            to: self.view
        ).maxY + 20 - displayHeihgt

        view.frame.origin.y == 0 ? (view.frame.origin.y -= bottomOffsetY) : ()
    }

    func keyboardDismiss(_ height: CGFloat) {
        view.frame.origin.y != 0 ? (view.frame.origin.y = 0) : ()
    }
}

extension EditBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        if let image = info[.originalImage] as? UIImage {
            bookImageView.contentMode = .scaleAspectFill
            bookImageView.image = image
        }
        self.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
