import UIKit

struct ImageResources {
    
    private typealias Internal = R.image
    
    struct Account {
        static var checkInBox: UIImage? { Internal.check_In_Box() }
        static var checkOffBox: UIImage? { Internal.check_Off_Box() }
    }
}
