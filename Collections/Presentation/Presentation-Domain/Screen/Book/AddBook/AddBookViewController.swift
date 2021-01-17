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
    @IBOutlet weak var validateTitleLabel: UILabel!
    @IBOutlet weak var validatePriceLabel: UILabel!
    @IBOutlet weak var validatePurchaseDateLabel: UILabel!

    var keyboardNotifier: KeyboardNotifier = KeyboardNotifier()

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: AddBookViewModel!

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(frame: .init(x: 0, y: 0, width: view.frame.width, height: 35))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tappedDoneButton))
        toolbar.setItems([spaceItem, doneItem], animated: true)
        return toolbar
    }()

    static func createInstance(viewModel: AddBookViewModel) -> AddBookViewController {
        let instance = AddBookViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTextField()
        setupButton()
        listenerKeyboard(keyboardNotifier: keyboardNotifier)
        bindValue()
        bindViewModel()
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

    @objc private  func tappedAddBookButton(_ sender: UIButton) {
        let imageString = bookImageView.image?.pngData()?.base64EncodedString()

        viewModel.addBook(
            name: bookTitleTextField.text ?? "",
            image: imageString,
            price: Int(bookPriceTextField.text ?? ""),
            purchaseDate: bookPurchaseDateTextField.text
        )
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

extension AddBookViewController {

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

        bookPurchaseDateTextField.rx.text
            .validate(PurchaseDateValidator.self)
            .map { validate in
                validate.errorDescription
            }
            .skip(2)
            .bind(to: validatePurchaseDateLabel.rx.text)
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
                guard let self = self else { return }

                self.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
            })
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        viewModel.result.asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [weak self] result in
                guard let self = self,
                      let result = result else { return }

                switch result {

                case .success(let response):
                    dump(response)

                    self.showAlert(
                        title: Resources.Strings.General.success,
                        message: Resources.Strings.App.successAddBook
                    ) {
                        self.router.dismiss(self)
                    }

                case .failure(let error):
                    if let error = error as? APIError {
                        dump(error.description())
                    }
                    self.showError(
                        title: Resources.Strings.General.error,
                        message: Resources.Strings.App.failedAddBook
                    )
                }
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
        let displayHeight = view.frame.height - height
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
            bookImageView.image = image
        }
        self.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true)
    }
}
