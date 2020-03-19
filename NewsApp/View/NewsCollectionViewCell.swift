//
//  NewsCollectionViewCell.swift
//  NewsApp
//
//  Created by rau4o on 3/10/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var cardView: UIView = {
        let view = UIView()
        view.addShadow()
        view.backgroundColor = .white
        return view
    }()
    
    var publisherLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = .black
        return label
    }()
    
    var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = .black
        return label
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .black
        label.backgroundColor = .white
        label.numberOfLines = 10
        return label
    }()
    
    var imageUrl: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.backgroundColor = .white
        return image
    }()
    
    // MARK: - Initial
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    // MARK: - Helper function
    
    private func configureUI() {
        addSubview(cardView)
        cardView.addSubview(imageUrl)
        cardView.addSubview(titleLabel)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(authorLabel)
        cardView.addSubview(publisherLabel)
        
        cardView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        
        imageUrl.anchor(top: cardView.topAnchor, left: cardView.leftAnchor, bottom: cardView.bottomAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 20, width: 150, height: 0)

        titleLabel.anchor(top: imageUrl.topAnchor, left: imageUrl.rightAnchor, right: cardView.rightAnchor,paddingTop: 0, paddingLeft: 10, paddingRight: 10,height: 40)
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, left: imageUrl.rightAnchor, bottom: imageUrl.bottomAnchor,right: cardView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0,paddingRight: 10, height: 70)
        
        authorLabel.anchor(top: imageUrl.bottomAnchor, left: imageUrl.leftAnchor, right: imageUrl.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingRight: 0, height: 10)
        
        publisherLabel.anchor(top: descriptionLabel.bottomAnchor, right: descriptionLabel.rightAnchor, paddingTop: 5, paddingRight: 0, width: 100, height: 10)
        
    }
    
    // MARK: -  Required init
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
