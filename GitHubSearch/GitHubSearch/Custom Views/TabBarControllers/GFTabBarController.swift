//
//  GFTabBarController.swift
//  GitHubSearch
//
//  Created by Jinyung Yoon on 2021/10/25.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().tintColor = .systemGreen
        viewControllers = [createNavigationController(title: "Search", vc: SearchVC(), type: .search, tag: 0),
                           createNavigationController(title: "Favorites", vc: FavoriteListVC(), type: .favorites, tag: 1)]
    }
    
    func createNavigationController(title: String, vc: UIViewController, type: UITabBarItem.SystemItem, tag: Int) -> UINavigationController {

        vc.title = title
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: type, tag: tag)
         
        return UINavigationController(rootViewController: vc)
    }
}
