//
//  MovieResult.swift
//  TheMovie
//
//  Created by Dang Quoc Huy on 7/27/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation

struct MovieResult: Decodable {
    var page:Int
    var totalResult:Int
    var totalPages:Int
    var arrayMovie: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResult = "total_results"
        case totalPages = "total_pages"
        case arrayMovie = "results"
    }
}
