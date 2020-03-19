//
//  WebService.swift
//  NewsApp
//
//  Created by rau4o on 3/9/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit
import Moya

class WebService: NSObject {
    
    var newsService = MoyaProvider<NewsService>()
    
    static let shared = WebService()
    
    func fetchEvery(completion: @escaping([Articles]?, Error?) -> Void) {
        newsService.request(.getEvery) { (result) in
            switch result {
            case .success(let response):
                do {
                    let every = try JSONDecoder().decode(Every.self, from: response.data).articles
                    completion(every, nil)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchNews(country: String,category: String, completion: @escaping([Articles]?, Error?) -> Void) {
        newsService.request(.getNews(country: country, category: category)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let news = try JSONDecoder().decode(Welcome.self, from: response.data).articles
                    completion(news,nil)
                } catch {
                    print(error.localizedDescription)
                }
            case .failure(let error):
                print("Error blya \(error.localizedDescription)")
            }
        }
    }
}
