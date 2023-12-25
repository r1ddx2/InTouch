//
//  ITTabBarViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//
import UIKit

class ITTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    private let tabs: [Tab] = [.home, .map, .draft, .activity, .profile]

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = .white

        viewControllers = tabs.map { $0.makeViewController() }

        delegate = self
    }
}

// MARK: - Tabs

extension ITTabBarViewController {
    private enum Tab {
        case home
        case map
        case draft
        case activity
        case profile

        func makeViewController() -> UIViewController {
            let controller: UIViewController
            switch self {
            case .home: controller = HomeViewController()
            case .map: controller = MapViewController()
            case .draft: controller = DraftViewController()
            case .activity: controller = ActivityViewController()
            case .profile: controller = ProfileViewController()
            }
            let navController = ITBaseNavigationController(rootViewController: controller)
            navController.tabBarItem = makeTabBarItem()
            navController.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0.0)

            return navController
        }

        private func makeTabBarItem() -> UITabBarItem {
            UITabBarItem(title: nil, image: image, selectedImage: selectedImage)
        }

        private var image: UIImage? {
            switch self {
            case .home:
                return UIImage(resource: .iconHome)
            case .map:
                return UIImage(resource: .iconMap)
            case .activity:
                return UIImage(resource: .iconActivity)
            case .draft:
                return UIImage(resource: .iconDraft)
            case .profile:
                return UIImage(resource: .iconProfile)
            }
        }

        private var selectedImage: UIImage? {
            switch self {
            case .home:
                return UIImage(resource: .iconHomeSelected).withRenderingMode(.alwaysOriginal)
            case .map:
                return UIImage(resource: .iconMapSelected).withRenderingMode(.alwaysOriginal)
            case .activity:
                return UIImage(resource: .iconActivitySelected).withRenderingMode(.alwaysOriginal)
            case .draft:
                return UIImage(resource: .iconDraft).withRenderingMode(.alwaysOriginal)
            case .profile:
                return UIImage(resource: .iconProfileSelected).withRenderingMode(.alwaysOriginal)
            }
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let index = tabBarController.viewControllers?.firstIndex(of: viewController),
           tabs[index] == .draft
        {
            let draftViewController = DraftViewController()
            let navController = ITBaseNavigationController(rootViewController: draftViewController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
