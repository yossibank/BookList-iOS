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
                self?.bookPurchaseDateTextField.endEditing(true)
                self?.bookPurchaseDateTextField.text = UIDatePicker
                    .purchaseDatePicker.date.toConvertString(
                        with: .yearToDayOfWeekJapanese
                    )
            }
            .store(in: &cancellables)

        toolbar.setItems(
            [spaceItem, doneItem],
            animated: true
        )

        return toolbar
    }()

    private var cancellables: Set<AnyCancellable> = []
}

// MARK: - override methods

extension EditBookViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupLayout()
        setupTextField()
        setupButton()
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
    }

    func setupLayout() {
        mainStackView.layout {
            $0.centerY == view.centerYAnchor
            $0.leading.equal(to: view.leadingAnchor, offsetBy: 64)
            $0.trailing.equal(to: view.trailingAnchor, offsetBy: -64)
        }

        bookImageView.layout {
            $0.heightConstant == 200
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

        bookTitleTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.bookName, on: viewModel)
            .store(in: &cancellables)

        bookPriceTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.bookPrice, on: viewModel)
            .store(in: &cancellables)

        bookPurchaseDateTextField.textPublisher
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.bookPurchaseDate, on: viewModel)
            .store(in: &cancellables)
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

    func bindViewModel() {
        viewModel.$state
            .sink { [weak self] state in
                switch state {
                    case .standby:
                        Logger.debug(message: "standby")

                    case .loading:
                        Logger.debug(message: "loading")

                    case let .done(entity):
                        Logger.debug(message: "\(entity)")
                        self?.dismiss(animated: true)

                    case let .failed(error):
                        Logger.debug(message: "\(error.localizedDescription)")
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
            bookImageView.contentMode = .scaleAspectFill
            bookImageView.image = image
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
