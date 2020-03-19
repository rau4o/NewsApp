//
//  TabBarController.swift
//  NewsApp
//
//  Created by rau4o on 3/13/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    
    // MARK: - Helper function
    
    fileprivate func configureViewControllers() {
        let topHideLines = UINavigationController(rootViewController: MainController())
        let everything = UINavigationController(rootViewController: EverythingController())
        
        topHideLines.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "home"), tag: 0)
        everything.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "list"), tag: 1)
        
        viewControllers = [topHideLines,everything]
    }
}
