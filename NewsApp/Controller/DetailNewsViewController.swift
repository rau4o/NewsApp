//
//  DetailNewsViewController.swift
//  NewsApp
//
//  Created by rau4o on 3/13/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit

class DetailNewsViewController: UIViewController {
    
    public static let shared = DetailNewsViewController()
    
    // MARK: - Properties
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 25)
        return label
    }()
    
    var publishedAt: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()

    var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    var textView: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 15)
        text.textColor = .black
        text.isEditable = false
        return text
    }()
    
    var linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        label.numberOfLines = 5
        label.sizeToFit()
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.addActionToLabel()
    }
    
    // MARK: - Helper function
    
    func addActionToLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleLabel(_:)))
        self.linkLabel.isUserInteractionEnabled = true
        self.linkLabel.addGestureRecognizer(tap)
    }
    
    fileprivate func configureUI() {
        self.view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(publishedAt)
        view.addSubview(imageView)
        view.addSubview(textView)
        view.addSubview(linkLabel)
        
        titleLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 100)
        
        publishedAt.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 30)
        
        imageView.anchor(top: publishedAt.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, height: 200)
        
        textView.anchor(top: imageView.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 200)
        
        linkLabel.anchor(top: textView.bottomAnchor, left: titleLabel.leftAnchor, bottom: nil, right: titleLabel.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
    }
    
    // MARK: - Selectors
    
    @objc func handleLabel(_ sender: UITapGestureRecognizer) {
        guard let url = (sender.view as? UILabel)?.text else {return}
        UIApplication.shared.open(URL(string: url)!)
    }
}
