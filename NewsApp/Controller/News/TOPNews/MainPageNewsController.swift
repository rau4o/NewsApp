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
private let headerCellId = "headerCellId"
private let rowHeight: CGFloat = 170
private let topHeaderHeight: CGFloat = 250

class MainPageNewsController: UIViewController {

    // MARK: - Properties
    
    var timer = Timer()
    
    var topNewsHeaderView: TopNewsCollectionReusableView!
    
    var refreshControl = UIRefreshControl()
    
    var refreshCollectionView: Bool = true
    
    var newsArticleArray = [Articles]()
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.sectionInset = .init(top: 100, left: 0, bottom: 0, right: 0)
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(TopNewsCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerCellId)
        collectionView.contentInsetAdjustmentBehavior = .never
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .vertical
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureRefreshControl(refreshControl)
        timerRefresh()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureActivityIndicator()
    }
    
    // MARK: - API
    
    fileprivate func fetchData() {
        WebService.shared.fetchNews(country: "us",category: "general") { (news, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let newsArticleData = news {
                for i in 0..<newsArticleData.count {
                    self.newsArticleArray.append(newsArticleData[i])
                }
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK: - Helper function
    
    func timerRefresh() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleUpdateWithTimer), userInfo: nil, repeats: true)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.title = "Top Hidelines"
        view.addSubview(collectionView)
        
        collectionView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
    }
    
    private func configureRefreshControl(_ refreshControll: UIRefreshControl) {
        refreshControll.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        refreshControll.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
        collectionView.addSubview(refreshControll)
    }
    
    fileprivate func configureActivityIndicator() {
        let fadeView = UIView()
        fadeView.frame = self.view.frame
        fadeView.backgroundColor = .white
        fadeView.alpha = 0.4
        self.view.addSubview(fadeView)
        
        self.view.addSubview(activityIndicator)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        activityIndicator.startAnimating()
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
            self.fetchData()
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, delay: 1, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.collectionView.reloadData()
                self.collectionView.alpha = 1
                fadeView.removeFromSuperview()
                self.activityIndicator.stopAnimating()
            })
        }
    }
    
    // MARK: - Selectors
    
    @objc private func handleRefreshControl() {
        self.collectionView.reloadData()
        if refreshCollectionView {
            refreshControl.endRefreshing()
        }
    }
    
    @objc private func handleUpdateWithTimer() {
        self.collectionView.reloadData()
    }
}

// MARK: - Extension UICollectionViewDelegate, UICollectionViewDataSource

extension MainPageNewsController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerCellId, for: indexPath) as! TopNewsCollectionReusableView
        header.imageView.image = #imageLiteral(resourceName: "placeholder")
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: topHeaderHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArticleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsCollectionViewCell
        cell.backgroundColor = .clear
        let news = newsArticleArray[indexPath.item]
        cell.titleLabel.text = news.title
        cell.descriptionLabel.text = news.description
        if let urlImage = news.urlToImage {
            cell.imageUrl.sd_setImage(with: URL(string: urlImage), placeholderImage: UIImage(named: "placeholder"))
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let news = newsArticleArray[indexPath.item]
        
        UIView.animate(withDuration: 0.5) {
            self.navigationController?.pushViewController(DetailNewsViewController.shared, animated: true)
            DetailNewsViewController.shared.titleLabel.text = news.title
            DetailNewsViewController.shared.publishedAt.text = news.publishedAt
            DetailNewsViewController.shared.textView.text = news.content
            DetailNewsViewController.shared.linkLabel.text = news.url
            if let imageUrl = news.urlToImage {
                DetailNewsViewController.shared.imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: #imageLiteral(resourceName: "placeholder"))
            }
        }
    }
}

// MARK: - API
    
//    func getData(country: String){
//        self.newsService.request(.getNews(country: country)) { (result) in
//            print(result)
//            switch result {
//            case .success(let response):
//                print(response)
//                do {
//                    let news = try JSONDecoder().decode(Welcome.self, from: response.data)
//                    print(news)
//                    if let newsArticlesData = news.articles {
//                        for i in 0..<newsArticlesData.count {
//                            self.newsArticleArray.append(newsArticlesData[i])
//                        }
//                    print(newsArticlesData)
//                    }
//                    DispatchQueue.main.async {
//                        self.collectionView.reloadData()
//                    }
//                }
//                catch {
//                    print("HUINYA \(error.localizedDescription)")
//                }
//            case .failure(let error):
//                print("DEBUG: \(error.localizedDescription)")
//            }
//        }
//    }


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
    
