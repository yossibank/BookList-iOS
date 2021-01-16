import UIKit
import RxSwift
import RxCocoa

final class AddBookViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var imageSelectButton: UIButton!
    @IBOutlet weak var takingPictureButton: UIButton!
    @IBOutlet weak var bookTitleTextField: UITextField!
    @IBOutlet weak var bookPriceTextField: UITextField!
    @IBOutlet weak var bookPurchaseDateTextField: UITextField!

    var keyboardNotifier: KeyboardNotifier = KeyboardNotifier()

    private let disposeBag: DisposeBag = DisposeBag()

    private lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.date = Date()
        datePicker.datePickerMode = .date
        datePicker.timeZone = .current
        datePicker.locale = Locale(identifier: "ja_JP")
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        return datePicker
    }()

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: view.frame.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDoneButton))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        return toolbar
    }()

    static func createInstance() -> AddBookViewController {
        AddBookViewController.instantiateInitialViewController()
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

extension AddBookViewController {

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Resources.Strings.Navigation.done,
            style: .done,
            target: self,
            action: #selector(tappedAddBookButton)
        )
    }

    private func setupTextField() {
        bookPurchaseDateTextField.inputView = datePicker
        bookPurchaseDateTextField.inputAccessoryView = toolbar

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

    @objc private  func tappedAddBookButton(_ sender: UIButton) {
        
    }

    @objc private func tappedDoneButton(_ sender: UIButton) {
        bookPurchaseDateTextField.endEditing(true)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        bookPurchaseDateTextField.text = formatter.string(from: datePicker.date)
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

extension AddBookViewController {

    private func bindValue() {
        Observable
            .combineLatest(
                bookTitleTextField.rx.text.orEmpty.map { $0.isEmpty },
                bookPriceTextField.rx.text.orEmpty.map { $0.isEmpty },
                bookPurchaseDateTextField.rx.text.orEmpty.map { $0.isEmpty })
            .map { isbookTitleEmpty, isBookPriceEmpty, isBookPurchaseDateEmpty in
                !(isbookTitleEmpty || isBookPriceEmpty || isBookPurchaseDateEmpty)
            }
            .subscribe(onNext: { [weak self] isEnabled in
                guard let self = self else { return }

                self.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
            })
            .disposed(by: disposeBag)
    }
}

extension AddBookViewController: UITextFieldDelegate {

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

extension AddBookViewController: KeyboardDelegate {

    func keyboardPresent(_ height: CGFloat) {
        let displayHeight = self.view.frame.height - height
        let bottomOffsetY = stackView.convert(
            bookPurchaseDateTextField.frame,
            to: self.view
        ).maxY + 20 - displayHeight

        view.frame.origin.y == 0 ? (view.frame.origin.y -= bottomOffsetY) : ()
    }

    func keyboardDismiss(_ height: CGFloat) {
        view.frame.origin.y != 0 ? (view.frame.origin.y = 0) : ()
    }
}

extension AddBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

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
