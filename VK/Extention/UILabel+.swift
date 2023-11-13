
import UIKit

extension UILabel {
    func countLines() -> Int {
      guard let myText = self.text as NSString? else {
        return 0
      }
      // Call self.layoutIfNeeded() if your view uses auto layout
        self.layoutIfNeeded()
      let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
      let labelSize = myText.boundingRect(with: rect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: self.font as Any], context: nil)
      return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }

}
