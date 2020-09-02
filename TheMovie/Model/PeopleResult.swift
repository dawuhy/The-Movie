//
//  PeopleResult.swift
//  TheMovie
//
//  Created by Huy on 9/1/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation

struct PeopleResult: Decodable {
    var page: Int?
    var totalResult: Int?
    var totalPage:Int?
    var results:[People]?
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResult = "total_results"
        case totalPage = "total_pages"
        case results
    }
}

//{
//"page": 1,
//"total_results": 10000,
//"total_pages": 500,
//"results": [
//  {
