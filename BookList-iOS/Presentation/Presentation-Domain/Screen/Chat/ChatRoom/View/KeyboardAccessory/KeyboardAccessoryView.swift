import UIKit

final class KeyboardAccessoryView: UIView {

    @IBOutlet weak var sendTextView: UITextView! {
        didSet {
            sendTextView.textContainerInset = .init(top: 8, left: 8, bottom: 4, right: 4)
            sendTextView.sizeToFit()
        }
    }

    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.imageView?.contentMode = .scaleAspectFill
            sendButton.contentVerticalAlignment = .fill
            sendButton.contentHorizontalAlignment = .fill
            sendButton.isEnabled = false
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override var intrinsicContentSize: CGSize {
        .zero
    }

    private func initializeLayout() {
        guard
            let view = KeyboardAccessoryView.initialize()
        else {
            return
        }

        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)

        autoresizingMask = .flexibleHeight
    }
}
