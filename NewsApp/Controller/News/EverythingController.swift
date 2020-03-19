//
//  EverythingController.swift
//  NewsApp
//
//  Created by rau4o on 3/13/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit
import Moya
import SDWebImage

// MARK: - Constants

private let reuseIdentifier = "cellId"
private let cellHeight: CGFloat = 150

class EverythingController: UIViewController {
    
    // MARK: - Properties
    
    var activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    var refresCollectioView: Bool = true
    
    var everyArray = [Articles]()
    
    let refreshControl = UIRefreshControl()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = .clear
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureRefreshControl(refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureActivityIndicator()
    }
    
    // MARK: - Helper function
    
    func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "Top Everything"
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              left: view.leftAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    fileprivate func configureActivityIndicator() {
        let fadeView = UIView()
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = .black
        fadeView.alpha = 0.4
        self.view.addSubview(fadeView)
        
        self.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        
        // MARK: - Download data
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.fetchEveryData()
        }
        
        // MARK: - ReloadCollectioView
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.collectionView.reloadData()
                self.collectionView.alpha = 1
                fadeView.removeFromSuperview()
                self.activityIndicator.stopAnimating()
            }, completion: nil)
        }
    }
    
    fileprivate func configureRefreshControl(_ refreshControl: UIRefreshControl) {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    // MARK: - API
       
    func fetchEveryData() {
        WebService.shared.fetchEvery { (every, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let everyArticleData = every {
                for i in 0..<everyArticleData.count {
                    self.everyArray.append(everyArticleData[i])
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc func handleRefresh() {
        if refresCollectioView {
            refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension EverythingController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return everyArray.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! NewsCollectionViewCell
        let every = everyArray[indexPath.item]
        cell.backgroundColor = .gray
        cell.titleLabel.text = every.title
        cell.descriptionLabel.text = every.description
        cell.publisherLabel.text = every.publishedAt
        cell.authorLabel.text = every.author
        if let imageUrl = every.urlToImage {
            cell.imageUrl.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let every = everyArray[indexPath.item]
        UIView.animate(withDuration: 0.5) {
            DetailNewsViewController.shared.titleLabel.text = every.title
            DetailNewsViewController.shared.publishedAt.text = every.publishedAt
            DetailNewsViewController.shared.textView.text = every.content
            DetailNewsViewController.shared.linkLabel.text = every.url
            if let imageUrl = every.urlToImage {
                DetailNewsViewController.shared.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: UIImage(named: "placeholder"))
            }
            self.navigationController?.pushViewController(DetailNewsViewController.shared, animated: true)
        }
    }
}
