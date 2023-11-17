//
//  ViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/16.
//

import UIKit

class ITBaseViewController: UIViewController {

    static var identifier: String {
        return String(describing: self)
    }
    
    var isHideNavigationBar: Bool {
        return false
    }

    var isEnableResignOnTouchOutside: Bool {
        return true
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        if isHideNavigationBar {
            navigationItem.hidesBackButton = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        IQKeyboardManager.shared.enable = isEnableIQKeyboard
        IQKeyboardManager.shared.shouldResignOnTouchOutside = isEnableResignOnTouchOutside
        
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }

        IQKeyboardManager.shared.enable = !isEnableIQKeyboard
        IQKeyboardManager.shared.shouldResignOnTouchOutside = !isEnableResignOnTouchOutside
    }

}

