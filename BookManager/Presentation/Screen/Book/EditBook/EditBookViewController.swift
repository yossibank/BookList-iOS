import Combine
import CombineCocoa
import UIKit
import Utility

extension EditBookViewController: VCInjectable {
    typealias R = NoRouting
    typealias VM = EditBookViewModel
}

// MARK: - properties

final class EditBookViewController: UIViewController {
    var routing: NoRouting!
    var viewModel: VM!

    private let mainStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 32
    )

    private let bookImageView: UIImageView = .init(
        style: .bookImageStyle
    )

    private let buttonStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 16
    )

    private let bookImageSelectButton: UIButton = .init(
        title: "画像を選択",
        backgroundColor: .darkGray,
        style: .fontBoldStyle
    )

    private let takingPictureButton: UIButton = .init(
        title: "写真を撮る",
        backgroundColor: .darkGray,
        style: .fontBoldStyle
    )

    private let bookTitleStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 4
    )

    private let bookTitleTextField: UITextField = .init(
        placeholder: "書籍名",
        style: .borderBottomStyle
    )

    private let bookPriceStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 4
    )

    private let bookPriceTextField: UITextField = .init(
        placeholder: "金額",
        style: .borderBottomStyle
    )

    private let bookPurchaseDateStackView: UIStackView = .init(
        style: .verticalStyle,
        spacing: 4
    )

    private let bookPurchaseDateTextField: UITextField = .init(
        placeholder: "購入日",
        style: .borderBottomStyle
    )

    private let loadingIndicator: UIActivityIndicatorView = .init(
        style: .largeStyle
    )

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
            action: nil
        )

        doneItem.tapPublisher
            .sink { [weak self] in
                self?.bookPurchaseDateTextField.text = UIDatePicker
                    .purchaseDatePicker.date.toConvertString(
                        with: .yearToDayOfWeekJapanese
                    )
                self?.bookPurchaseDateTextField.endEditing(true)
            }
            .store(in: &cancellables)

        toolbar.setItems(
            [spaceItem, doneItem],
            animated: true
        )

        return toolbar
    }()

    private var cancellables: Set<AnyCancellable> = []
    private var successHandler: ((BookBusinessModel) -> Void)?

    static func createInstance(
        successHandler: ((BookBusinessModel) -> Void)?
    ) -> EditBookViewController {
        let instance = EditBookViewController()
        instance.successHandler = successHandler
        return instance
    }
}

// MARK: - override methods

extension EditBookViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupTextField()
        setupButton()
        setupInitialValue()
        bindValue()
        bindViewModel()
    }

    override func touchesBegan(
        _: Set<UITouch>,
        with _: UIEvent?
    ) {
        view.endEditing(true)
    }
}

// MARK: - private methods

private extension EditBookViewController {

    func setupView() {
        view.backgroundColor = .white

        bookTitleStackView.addArrangedSubview(bookTitleTextField)
        bookPriceStackView.addArrangedSubview(bookPriceTextField)
        bookPurchaseDateStackView.addArrangedSubview(bookPurchaseDateTextField)

        let buttonStackViewList = [
            bookImageSelectButton,
            takingPictureButton
        ]

        buttonStackViewList.forEach {
            buttonStackView.addArrangedSubview($0)
        }

        let stackViewList = [
            bookImageView,
            buttonStackView,
            bookTitleStackView,
            bookPriceStackView,
            bookPurchaseDateStackView
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
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 64)
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -64)
        }

        loadingIndicator.layout {
            $0.centerX == view.centerXAnchor
            $0.centerY == view.centerYAnchor
        }

        bookImageView.layout {
            $0.heightConstant == 220
        }

        [bookTitleTextField, bookPriceTextField, bookPurchaseDateTextField].forEach {
            $0.layout {
                $0.heightConstant == 30
            }
        }
    }

    func setupTextField() {
        [bookTitleTextField, bookPriceTextField, bookPurchaseDateTextField].forEach {
            $0?.delegate = self
        }

        bookPurchaseDateTextField.inputAccessoryView = toolbar
        bookPurchaseDateTextField.inputView = UIDatePicker.purchaseDatePicker
    }

    func setupButton() {
        navigationItem.rightBarButtonItem?.tapPublisher
            .sink { [weak self] in
                self?.viewModel.editBook()
            }
            .store(in: &cancellables)

        bookImageSelectButton.tapPublisher
            .sink { [weak self] in
                let photoLibrary = UIImagePickerController.SourceType.photoLibrary

                if UIImagePickerController.isSourceTypeAvailable(photoLibrary) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.delegate = self
                    self?.present(picker, animated: true)
                }
            }
            .store(in: &cancellables)

        takingPictureButton.tapPublisher
            .sink { [weak self] in
                let camera = UIImagePickerController.SourceType.camera

                if UIImagePickerController.isSourceTypeAvailable(camera) {
                    let picker = UIImagePickerController()
                    picker.sourceType = .camera
                    picker.delegate = self
                    self?.present(picker, animated: true)
                }
            }
            .store(in: &cancellables)
    }

    func setupInitialValue() {
        bookImageView.loadImage(with: .string(urlString: viewModel.bookImage))
        bookTitleTextField.text = viewModel.bookName
        bookPriceTextField.text = viewModel.bookPrice
        bookPurchaseDateTextField.text = Date.convertBookPurchaseDate(
            dateString: viewModel.bookPurchaseDate
        )

        // 画像をそのまま編集せずに完了ボタンを押した際にbase64に変換しておく
        viewModel.bookImage = bookImageView.image?.convertBase64String() ?? String.blank
    }

    func bindValue() {
        bookImageView.base64ImagePublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.bookImage, on: viewModel)
            .store(in: &cancellables)

        bookTitleTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.bookName, on: viewModel)
            .store(in: &cancellables)

        bookPriceTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.bookPrice, on: viewModel)
            .store(in: &cancellables)

        bookPurchaseDateTextField.textDatePickerPublisher
            .receive(on: DispatchQueue.main)
            .compactMap {
                Date.toConvertDate(
                    $0, with: .yearToDayOfWeekJapanese
                )?.toConvertString(with: .yearToDayOfWeek)
            }
            .assign(to: \.bookPurchaseDate, on: viewModel)
            .store(in: &cancellables)
    }

    func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }

                switch state {
                    case .standby:
                        self.loadingIndicator.stopAnimating()

                    case .loading:
                        self.loadingIndicator.startAnimating()

                    case let .done(entity):
                        let book = self.viewModel.mapBookEntityToBusinessModel(entity: entity)

                        self.loadingIndicator.stopAnimating()
                        self.successHandler?(book)

                        let okAction = UIAlertAction(
                            title: "OK",
                            style: .default
                        ) { [weak self] _ in
                            self?.dismiss(animated: true)
                        }

                        self.showAlert(title: "書籍編集完了", actions: [okAction])

                    case let .failed(error):
                        self.loadingIndicator.stopAnimating()
                        self.showError(error: error)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Delegate

extension EditBookViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let textFields = [bookTitleTextField, bookPriceTextField, bookPurchaseDateTextField]

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

extension EditBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(
        _: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let image = info[.originalImage] as? UIImage {
            bookImageView.image = image

            NotificationCenter.default.post(
                name: .didSetImageIntoImageView,
                object: nil,
                userInfo: ["base64Image": image.convertBase64String()]
            )
        }
        dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true)
    }
}

// MARK: - Protocol

extension EditBookViewController: NavigationBarConfiguration {

    var navigationTitle: String? {
        Resources.Strings.Navigation.Title.bookEdit
    }

    var rightBarButton: [NavigationBarButton] {
        [.done]
    }
}
