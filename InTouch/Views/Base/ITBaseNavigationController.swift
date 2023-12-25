//
//  ITBaseNavigationController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//
import UIKit

class ITBaseNavigationController: UINavigationController {
    var backgroundColor: UIColor = .ITYellow

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = backgroundColor
        var appearance = UINavigationBarAppearance()
        appearance.backgroundColor = backgroundColor
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.ITBlack]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
    }
}
