//
//  ITBaseNavigationController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//
import UIKit

class ITBaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.backgroundColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.isTranslucent = false
    }
}
