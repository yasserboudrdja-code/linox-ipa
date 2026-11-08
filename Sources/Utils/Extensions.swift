import UIKit

extension UIColor {
    convenience init(hex: String) {
        var h = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        h = h.hasPrefix("#") ? String(h.dropFirst()) : h
        var rgb: UInt64 = 0
        Scanner(string: h).scanHexInt64(&rgb)
        self.init(red: CGFloat((rgb>>16)&0xFF)/255,
                  green: CGFloat((rgb>>8)&0xFF)/255,
                  blue: CGFloat(rgb&0xFF)/255,
                  alpha: 1)
    }
}
extension UILabel {
    func setLetterSpacing(_ s: CGFloat) {
        guard let t = text else { return }
        let a = NSMutableAttributedString(string: t)
        a.addAttribute(.kern, value: s, range: NSRange(location:0, length:max(0,t.count-1)))
        attributedText = a
    }
}
