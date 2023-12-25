//
//  UITextField + Extension.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/7.
//

import UIKit

extension UITextField {
    func addPadding(left: CGFloat, right: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: left, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always

        let paddingViewRight = UIView(frame: CGRect(x: 0, y: 0, width: right, height: frame.size.height))
        rightView = paddingViewRight
        rightViewMode = .always
    }
}
