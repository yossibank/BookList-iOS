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
    @IBOutlet weak var validatePurchaseDateLabel: UILabel!

    var keyboardNotifier: KeyboardNotifier = KeyboardNotifier()

    private let router: RouterProtocol = Router()
    private let disposeBag: DisposeBag = DisposeBag()

    private var viewModel: EditBookViewModel!
    private var bookViewData: BookViewData!
    private var successHandler: ((BookViewData) -> Void)?

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar(
            frame: .init(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: 35
            )
        )

        let spaceItem = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )

        let doneItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )

        toolbar.setItems(
            [spaceItem, doneItem],
            animated: true
        )

        return toolbar
    }()

    static func createInstance(
        viewModel: EditBookViewModel,
        bookViewData: BookViewData,
        successHandler: ((BookViewData) -> Void)?
    ) -> EditBookViewController {
        let instance = EditBookViewController.instantiateInitialViewController()
        instance.viewModel = viewModel
        instance.bookViewData = bookViewData
        instance.successHandler = successHandler
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupTextField()
        setupButton()
        setupBookViewData()
        bindValue()
        bindViewModel()
        listenerKeyboard(keyboardNotifier: keyboardNotifier)
        sendScreenView()
    }
}

extension EditBookViewController {

    private func setupNavigation() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: Resources.Strings.Navigation.done,
            style: .done,
            target: self,
            action: #selector(editBookButtonTapped)
        )
    }

    private func setupTextField() {
        bookPurchaseDateTextField.inputAccessoryView = toolbar
        bookPurchaseDateTextField.inputView = UIDatePicker.purchaseDatePicker

        [bookTitleTextField, bookPriceTextField, bookPurchaseDateTextField]
            .forEach { $0?.delegate = self }
    }

    private func setupButton() {
        imageSelectButton.rx.tap.subscribe { [weak self] _ in
            self?.setupPhotoLibrary()
        }.disposed(by: disposeBag)

        takingPictureButton.rx.tap.subscribe { [weak self] _ in
            self?.setupLaunchCamera()
        }.disposed(by: disposeBag)
    }

    private func setupPhotoLibrary() {
        let photoLibrary = UIImagePickerController.SourceType.photoLibrary

        if UIImagePickerController.isSourceTypeAvailable(photoLibrary) {
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }

    private func setupLaunchCamera() {
        let camera = UIImagePickerController.SourceType.camera

        if UIImagePickerController.isSourceTypeAvailable(camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            self.present(picker, animated: true)
        }
    }

    @objc private  func editBookButtonTapped() {
        if let name = bookTitleTextField.text,
           let price = bookPriceTextField.text,
           let purchaseDate = bookPurchaseDateTextField.text {

            let imageString = bookImageView.image?.pngData()?.base64EncodedString()
            let purchaseDateFormat = Date.toConvertDate(
                purchaseDate,
                with: .yearToDayOfWeekJapanese
            )?.toConvertString(with: .yearToDayOfWeek)

            viewModel.editBook(
                name: name,
                image: imageString,
                price: Int(price),
                purchaseDate: purchaseDateFormat
            )
        }
    }

    @objc private func doneButtonTapped() {
        bookPurchaseDateTextField.text =
            UIDatePicker.purchaseDatePicker.date.toConvertString(with: .yearToDayOfWeekJapanese)
        bookPurchaseDateTextField.endEditing(true)
    }
}

extension EditBookViewController {

    private func setupBookViewData() {
        bookTitleTextField.text = bookViewData.name

        if let price = bookViewData.price {
            bookPriceTextField.text = price.description
        }

        if let purchaseDate = bookViewData.purchaseDate {
            if let dateFormat = Date.toConvertDate(purchaseDate, with: .yearToDayOfWeek) {
                bookPurchaseDateTextField.text = dateFormat.toConvertString(with: .yearToDayOfWeekJapanese)
            }
        }

        if let imageUrl = bookViewData.image {
            ImageLoader.shared.loadImage(
                with: .string(urlString: imageUrl)
            ) { [weak self] image, _ in
                self?.bookImageView.image = image
            }
        }
    }

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
                self?.navigationItem.rightBarButtonItem?.isEnabled = isEnabled
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
                    self.showAlert(
                        title: Resources.Strings.General.success,
                        message: Resources.Strings.Alert.successEditBook
                    ) { [weak self] in
                        guard let self = self else { return }

                        let bookData = self.viewModel.map(
                            book: response.result,
                            isFavorite: self.bookViewData.isFavorite
                        )

                        self.viewModel.updateBook(book: bookData)
                        self.successHandler?(bookData)
                        self.router.dismiss(self)
                    }

                case .failure(let error):
                    if let error = error as? APIError {
                        dump(error.description())
                    }
                    self.showError(
                        title: Resources.Strings.General.error,
                        message: Resources.Strings.Alert.failedEditBook
                    )
                }
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

extension EditBookViewController: AnalyticsConfiguration {
    var screenName: AnalyticsScreenName? { .editBook }
}
