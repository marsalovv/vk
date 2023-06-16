
import UIKit

extension UIColor {
    
    static func color(light: UIColor, dark: UIColor) -> UIColor {
        return UIColor.init { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? dark : light
        }
    }
    
    struct Pallete {
        
        static let white = color(light: .white, dark: .black)
        static let black = color(light: .black, dark: .white)
        
    }
    
}



