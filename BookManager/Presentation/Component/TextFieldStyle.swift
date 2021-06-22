import UIKit

extension Stylable where Self == UITextField {

    init(
        placeholder: String = String.blank,
        keyboardType: UIKeyboardType = .default,
        style: ViewStyle<Self>)
    {
        self.init()
        self.autocapitalizationType = .none
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.apply(style)
    }
}


extension ViewStyle where T: UITextField {

    static var borderBottomStyle: ViewStyle<T> {
        ViewStyle<T> {
            $0.layer.backgroundColor = UIColor.white.cgColor
            $0.layer.shadowColor = UIColor.lightGray.cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowRadius = 0
            $0.layer.shadowOffset = .init(width: 0, height: 0.4)
        }
    }
    
    static var securePassword: ViewStyle<T> {
        ViewStyle<T> {
            $0.isSecureTextEntry = true
            $0.layer.backgroundColor = UIColor.white.cgColor
            $0.layer.shadowColor = UIColor.lightGray.cgColor
            $0.layer.shadowOpacity = 1
            $0.layer.shadowRadius = 0
            $0.layer.shadowOffset = .init(width: 0, height: 0.4)
        }
    }
}
