
import Foundation

prefix operator ~
prefix func ~ (string: String) -> String {
    return NSLocalizedString(string, comment: "")
}
