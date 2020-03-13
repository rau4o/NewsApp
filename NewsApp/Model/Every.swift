//
//  Every.swift
//  NewsApp
//
//  Created by rau4o on 3/13/20.
//  Copyright © 2020 rau4o. All rights reserved.
//

import UIKit

struct Every: Decodable {
    let status: String
    let totalResults: Int
    let articles: [Articles]?
}
