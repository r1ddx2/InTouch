//
//  UIFont + Extension.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//

import UIKit

private enum ITFontName: String {
    case regular = "HelveticaNeue"
    case ultraLight = "HelveticaNeue-UltraLight"
    case light = "HelveticaNeue-Light"
    case thin = "HelveticaNeue-Thin"
    case medium = "HelveticaNeue-Medium"
    case bold = "HelveticaNeue-Bold"
}

extension UIFont {
  
    static func regular(size: CGFloat) -> UIFont? {
        return ITFont(.regular, size: size)
    }
    static func ultraLight(size: CGFloat) -> UIFont? {
        return ITFont(.ultraLight, size: size)
    }

    static func light(size: CGFloat) -> UIFont? {
        return ITFont(.light, size: size)
    }

    static func thin(size: CGFloat) -> UIFont? {
        return ITFont(.thin, size: size)
    }

    static func medium(size: CGFloat) -> UIFont? {
        return ITFont(.medium, size: size)
    }

    static func bold(size: CGFloat) -> UIFont? {
        return ITFont(.bold, size: size)
    }
    
    private static func ITFont(_ font: ITFontName, size: CGFloat) -> UIFont? {
        return UIFont(name: font.rawValue, size: size)
    }
    
}
