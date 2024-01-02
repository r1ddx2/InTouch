//
//  ITBaseNavigationController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//
import UIKit

class ITBaseNavigationController: UINavigationController {
    static var shared: UINavigationController?

    var backgroundColor: UIColor = .ITYellow

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = backgroundColor
        navigationBar.tintColor = .ITBlack
        var appearance = UINavigationBarAppearance()
        appearance.backgroundColor = backgroundColor
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.ITBlack]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
    }
}
