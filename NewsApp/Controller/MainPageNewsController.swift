//
//  MainPageNewsController.swift
//  NewsApp
//
//  Created by rau4o on 3/9/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit
import Moya
import SDWebImage

// MARK: - Constants

private let cellId = "cellId"
private let rowHeight: CGFloat = 170

class MainPageNewsController: UIViewController {

    // MARK: - Properties
    
    var refreshControl = UIRefreshControl()
    
    var refreshCollectionView: Bool = true
    
    var newsService = MoyaProvider<NewsService>()
    
    var newsArticleArray = [Articles]()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = .red
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getData(country: "us")
        configureRefreshControl(refreshControl)
    }
    
    // MARK: - API
//        self.newsService.request(.getNews) { (result) in
//            switch result {
//                case .success(let response):
//                    print(response.statusCode)
//                    print(response.data)
//                    if let news = try? JSONDecoder().decode(Welcome.self, from: response.data) {
//                        print("Print\(news)")
////                        self.newsArr = news.articles
//                        DispatchQueue.main.async {
//                            self.collectionView.reloadData()
//                        }
//                    }
//                case .failure(let error):
//                    print("DEBUG: Error \(error.localizedDescription)")
//                    return
//               }
//           }
       //}
    
//    func getData() {
//        WebService.shared.getData { (welcome, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            self.newsArr = welcome.articles
//            print(self.newsArr[0])
//            DispatchQueue.main.async {
//                self.collectionView.reloadData()
//            }
//        }
//    }
    
    // MARK: - Helper function
    
    private func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "NEWS"
        
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    private func configureRefreshControl(_ refreshControll: UIRefreshControl) {
        refreshControll.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControll.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControll)
    }
    
    // MARK: - Selectors
    
    @objc private func handleRefreshControl() {
        self.collectionView.reloadData()
        if refreshCollectionView {
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - Extension UICollectionViewDelegate, UICollectionViewDataSource

extension MainPageNewsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArticleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsCollectionViewCell
        cell.backgroundColor = .white
        let news = newsArticleArray[indexPath.item]
        cell.titleLabel.text = news.title
        cell.descriptionLabel.text = news.description
        if let urlImage = news.urlToImage {
            cell.imageUrl.sd_setImage(with: URL(string: urlImage), placeholderImage: UIImage(named: "layer-5"))
        }
        cell.authorLabel.text = news.author
        cell.publisherLabel.text = news.publishedAt
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 20, height: rowHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

// MARK: - API

extension MainPageNewsController {
    
    func getData(country: String){
        self.newsService.request(.getNews(country: country)) { (result) in
            print(result)
            switch result {
            case .success(let response):
                print(response)
                do {
                    let news = try JSONDecoder().decode(Welcome.self, from: response.data)
                    print(news)
                    if let newsArticlesData = news.articles {
                        for i in 0..<newsArticlesData.count {
                            self.newsArticleArray.append(newsArticlesData[i])
                        }
                    print(newsArticlesData)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
                catch {
                    print("HUINYA \(error.localizedDescription)")
                }
            case .failure(let error):
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
}
