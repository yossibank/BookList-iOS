import UIKit

final class KeyboardAccessoryView: UIView {

    @IBOutlet weak var sendTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
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
    }
}
