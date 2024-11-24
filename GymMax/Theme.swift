import SwiftUI

struct Theme {
    static let primaryGradient = LinearGradient(
        colors: [
            Color(uiColor: UIColor(hex: "1A1A2E")!),
            Color(uiColor: UIColor(hex: "16213E")!),
            Color(uiColor: UIColor(hex: "0F3460")!)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let accentColor = Color(uiColor: UIColor(hex: "E94560")!)
    static let secondaryColor = Color(uiColor: UIColor(hex: "533483")!)
    
    static let cardBackground = Color(uiColor: UIColor(hex: "1A1A2E")!).opacity(0.7)
}

extension UIColor {
    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff0000) >> 16) / 255
                    g = CGFloat((hexNumber & 0x00ff00) >> 8) / 255
                    b = CGFloat(hexNumber & 0x0000ff) / 255
                    a = 1.0

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        return nil
    }
}
