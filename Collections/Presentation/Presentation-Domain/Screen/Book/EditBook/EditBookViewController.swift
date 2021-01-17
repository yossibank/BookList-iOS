import UIKit

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

    static func createInstance() -> EditBookViewController {
        EditBookViewController.instantiateInitialViewController()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupButton()
    }
}

extension EditBookViewController {

    private func setupTextField() {
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
