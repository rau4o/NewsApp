//
//  NewsService.swift
//  NewsApp
//
//  Created by rau4o on 3/9/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit
import Moya

enum NewsService {
    case getNews(country: String)
    case getEvery
}

extension NewsService: TargetType {
    var baseURL: URL {
        return URL(string: "http://newsapi.org/v2/")!
//        http://newsapi.org/v2/everything?q=bitcoin&apiKey=f12fc7d8e0df4337a19981fea52f3811
    }
    
    var path: String {
        switch self {
        case .getNews:
            return "top-headlines"
        case .getEvery:
            return "everything"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        return Data()   
    }
    
    var task: Task {
        switch self {
        case .getNews(let country):
            return .requestParameters(parameters: ["country": country, "apiKey": "f12fc7d8e0df4337a19981fea52f3811","pageSize": 15], encoding: URLEncoding.default)
        case .getEvery:
            return .requestParameters(parameters: ["q": "bitcoin", "apiKey": "f12fc7d8e0df4337a19981fea52f3811", "pageSize": 15], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
}
