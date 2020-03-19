//
//  UIView+Extension.swift
//  NewsApp
//
//  Created by rau4o on 3/19/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShad() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
}
