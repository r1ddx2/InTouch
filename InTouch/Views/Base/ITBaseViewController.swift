//
//  ViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/16.
//
//MARK: - Init
import UIKit
import IQKeyboardManagerSwift

class ITBaseViewController: UIViewController {
    
    static var identifier: String {
        return String(describing: self)
    }
    var isHideNavigationBarOnScroll: Bool {
        return false
    }
    var isHideNavigationBar: Bool {
        return false
    }
    var isEnableResignOnTouchOutside: Bool {
        return true
    }
    var isHideTabBar: Bool {
        return false
    }
    var isEnableIQKeyboard: Bool {
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        if isHideNavigationBar {
            navigationItem.hidesBackButton = true
        }
        if isHideNavigationBarOnScroll {
            navigationController?.hidesBarsOnSwipe = true
        }
        if isHideTabBar {
            tabBarController?.tabBar.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: false)
        }
        if isHideTabBar {
            tabBarController?.tabBar.isHidden = true
        }
        
        IQKeyboardManager.shared.enable = isEnableIQKeyboard
        IQKeyboardManager.shared.shouldResignOnTouchOutside = isEnableResignOnTouchOutside
        
        setNeedsStatusBarAppearanceUpdate()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        if isHideTabBar {
            tabBarController?.tabBar.isHidden = false
        }
        IQKeyboardManager.shared.enable = !isEnableIQKeyboard
        IQKeyboardManager.shared.shouldResignOnTouchOutside = !isEnableResignOnTouchOutside
    }
    // MARK: - Methods
    func popBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
   
}
// MARK: - UIImagePickerView
extension ITBaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}
// MARK: - Instantiate View Controller
extension ITBaseViewController {
    func showAddGroupPage() {
        
        let addGroupVC = AddGroupViewController()
        addGroupVC.isModalInPresentation = true
        
        if #available(iOS 16.0, *) {
            if let sheetPresentationController = addGroupVC.sheetPresentationController {
                sheetPresentationController.accessibilityRespondsToUserInteraction = true
                sheetPresentationController.preferredCornerRadius = 16
                sheetPresentationController.detents = [.custom(resolver: { _ in
                    220
                })]
            }
            present(addGroupVC, animated: true, completion: nil)
        }
        
        
    }
    func showConfirmJoinPage(for group: Group) {
        let confirmJoinVC = ConfirmJoinGroupViewController()
        confirmJoinVC.group = group
        
        if #available(iOS 16.0, *) {
            if let sheetPresentationController = confirmJoinVC.sheetPresentationController {
                sheetPresentationController.accessibilityRespondsToUserInteraction = true
                sheetPresentationController.preferredCornerRadius = 16
                sheetPresentationController.detents = [.custom(resolver: { _ in
                    680
                })]
            }
            present(confirmJoinVC, animated: true, completion: nil)
        }
    }
}
// MARK: - Common methods
extension ITBaseViewController {
    func generateRandomCode() -> String {
        let randomString = UUID().uuidString.replacingOccurrences(of: "-", with: "")
          return "\(randomString)"
    }
}


extension UIViewController {
    func dismissToRoot() {
        
        if presentingViewController != nil {
            let superVC = presentingViewController
            dismiss(animated: false, completion: nil)
            superVC?.dismissToRoot()
            return
            
            
        }
        
    }
}
