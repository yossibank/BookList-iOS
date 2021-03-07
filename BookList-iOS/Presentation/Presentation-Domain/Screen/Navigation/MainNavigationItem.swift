import UIKit

final class MainNavigationButton: UIButton {

    private struct Constant {
        static let buttonSize: CGSize = CGSize(width: 40, height: 40)
    }

    init(image: UIImage?) {
        super.init(frame: .init(origin: .zero, size: Constant.buttonSize))
        setImage(image, for: .normal)
    }

    init(text: String?) {
        super.init(frame: .init(origin: .zero, size: Constant.buttonSize))
        setTitle(text, for: .normal)
        setTitleColor(.gray, for: .disabled)
        setTitleColor(.systemBlue, for: .normal)
        setTitleColor(.blue, for: .highlighted)
        titleLabel?.font = .boldSystemFont(ofSize: 16)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        bounds.size = Constant.buttonSize
    }
}
