//
//  ViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/16.
//
//MARK: - Init
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
    var isHideTabBar: Bool {
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if isHideNavigationBar {
            navigationItem.hidesBackButton = true
        }
        if isHideTabBar {
            tabBarController?.tabBar.isHidden = true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        if isHideTabBar {
            tabBarController?.tabBar.isHidden = true
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        if isHideTabBar {
            tabBarController?.tabBar.isHidden = false
        }
    }
    func popBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
 
}

extension ITBaseViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

