//
//  ITBaseViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/16.
//

// MARK: - Init

import IQKeyboardManagerSwift
import UIKit

class ITBaseViewController: UIViewController {
    static var identifier: String {
        String(describing: self)
    }

    var isHideNavigationBarOnScroll: Bool {
        false
    }

    var isHideNavigationBar: Bool {
        false
    }

    var isEnableResignOnTouchOutside: Bool {
        true
    }

    var isHideTabBar: Bool {
        false
    }

    var isEnableIQKeyboard: Bool {
        true
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

    func popBack(_: UIButton) {
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
        configureSheetPresent(vc: addGroupVC, height: 220)
    }

    func configureSheetPresent(vc: ITBaseViewController, height: CGFloat) {
        if let sheetPresentationController = vc.sheetPresentationController {
            sheetPresentationController.accessibilityRespondsToUserInteraction = true
            sheetPresentationController.preferredCornerRadius = 16
            sheetPresentationController.detents = [.custom(resolver: { _ in
                height
            })]
            present(vc, animated: true, completion: nil)
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
