//
//  TopNewsCollectionReusableView.swift
//  NewsApp
//
//  Created by rau4o on 3/12/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit

class TopNewsCollectionReusableView: UICollectionReusableView {
   
    // MARK: - Properties
    
    var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .black
        return image
    }()
    
    // MARK: - Initial
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    // MARK: - Helper function
    
    private func configureUI() {
        addSubview(imageView)
        
        imageView.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    // MARK: - required init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
