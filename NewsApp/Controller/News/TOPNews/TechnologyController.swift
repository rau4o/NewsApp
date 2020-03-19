//
//  TechnologyController.swift
//  NewsApp
//
//  Created by rau4o on 3/15/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit
import Moya
import SDWebImage

private let cellId = "cellId"
private let rowHeight: CGFloat = 170

class TechnologyController: UIViewController {
    
    // MARK: - Properties
    
    lazy var collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    var techArray = [Articles]()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        fetchTech()
    }
    
    // MARK: - Helper function
    
    private func configureUI() {
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    // MARK: - API
    
    fileprivate func fetchTech() {
        WebService.shared.fetchNews(country: "us", category: "technology") { (news, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let newsData = news {
                for i in 0..<newsData.count {
                    self.techArray.append(newsData[i])
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate,UICollectionViewDataSource

extension TechnologyController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return techArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsCollectionViewCell
        cell.backgroundColor = .gray
        let news = techArray[indexPath.item]
        cell.titleLabel.text = news.title
        cell.descriptionLabel.text = news.description
        cell.publisherLabel.text = news.publishedAt
        cell.authorLabel.text = news.author
        if let imgUrl = news.urlToImage {
            cell.imageUrl.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: "placeholder"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: rowHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let news = techArray[indexPath.item]
        
        UIView.animate(withDuration: 0.5) {
            self.navigationController?.pushViewController(DetailNewsViewController.shared, animated: true)
            DetailNewsViewController.shared.titleLabel.text = news.title
            DetailNewsViewController.shared.publishedAt.text = news.publishedAt
            DetailNewsViewController.shared.textView.text = news.content
            DetailNewsViewController.shared.linkLabel.text = news.url
            if let imageUrl = news.urlToImage {
                DetailNewsViewController.shared.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
            }
        }
    }
}
