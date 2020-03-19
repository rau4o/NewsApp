//
//  MainController.swift
//  NewsApp
//
//  Created by rau4o on 3/15/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit
import BmoViewPager

class MainController: UIViewController {
    
    // MARK: - Properties
    
    lazy var BmoPager: BmoViewPager = {
        let bmo = BmoViewPager()
        bmo.delegate = self
        bmo.dataSource = self
        bmo.scrollable = true
        
        return bmo
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureBmo()
    }
    
    // MARK: - Helper function
    
    fileprivate func configureUI() {
        view.addSubview(BmoPager)
        
        BmoPager.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    fileprivate func configureBmo() {
        let navigationBar = BmoViewPagerNavigationBar(frame: CGRect(origin: .zero, size: .init(width: view.frame.width, height: 30)))
        self.navigationItem.titleView = navigationBar
        navigationBar.backgroundColor = .clear
        navigationBar.viewPager = BmoPager
    }
}


// MARK: - BmoViewPagerDataSource, BmoViewPagerDelegate

extension MainController: BmoViewPagerDataSource, BmoViewPagerDelegate {
    
    func bmoViewPagerDataSourceNaviagtionBarItemNormalAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.strokeWidth     : 1.0,
            NSAttributedString.Key.strokeColor     : UIColor.black,
            NSAttributedString.Key.foregroundColor : UIColor.groupTableViewBackground
        ]
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemHighlightedAttributed(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> [NSAttributedString.Key : Any]? {
        return [
            NSAttributedString.Key.foregroundColor : UIColor.black
        ]
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemSize(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> CGSize {
        CGSize(width: navigationBar.bounds.width / 2, height: navigationBar.bounds.height)
    }
    
    func bmoViewPagerDataSourceNaviagtionBarItemTitle(_ viewPager: BmoViewPager, navigationBar: BmoViewPagerNavigationBar, forPageListAt page: Int) -> String? {
        switch page {
        case 0:
            return "Main"
        case 1:
            return "Entertaiment"
        case 2:
            return "Business"
        case 3:
            return "Technology"
        default:
            break
        }
        return ""
    }
    
    func bmoViewPagerDataSourceNumberOfPage(in viewPager: BmoViewPager) -> Int {
        return 4
    }

    func bmoViewPagerDataSource(_ viewPager: BmoViewPager, viewControllerForPageAt page: Int) -> UIViewController {
        switch page {
        case 0:
            let vc1 = MainPageNewsController()
            return vc1
        case 1:
            let vc2 = EntertainmentController()
            return vc2
        case 2:
            let vc3 = BusinessController()
            return vc3
        case 3:
            let vc4 = TechnologyController()
            return vc4
        default:
            break
        }
        return UIViewController()
    }
}
