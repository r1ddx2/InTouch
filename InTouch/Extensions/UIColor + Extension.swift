//
//  UIColor + Extension.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: Float = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha)
        )
    }

    convenience init(hex: String, alpha: Float = 1.0) {
        let hexValue = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        var rgbValue: UInt64 = 0
        Scanner(string: hexValue).scanHexInt64(&rgbValue)

        let red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
        return
    }

    static let ITBlack = UIColor(red: 3, green: 3, blue: 3)
    static let ITYellow = UIColor(red: 255, green: 209, blue: 82)
    static let ITVeryLightGrey = UIColor(red: 235, green: 235, blue: 235, alpha: 53)
    static let ITVeryLightPink = UIColor(red: 227, green: 227, blue: 227, alpha: 57)
    static let ITTransparentGrey = UIColor(red: 235, green: 235, blue: 235, alpha: 0.4)
    static let ITDarkGrey = UIColor(red: 93, green: 93, blue: 91)
    static let ITLightGrey = UIColor(red: 194, green: 194, blue: 194)
    static let ITPurple = UIColor(red: 190, green: 173, blue: 250, alpha: 0.8)
}
