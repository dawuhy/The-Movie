//
//  MovieAPI.swift
//  TheMovie
//
//  Created by Dang Quoc Huy on 7/27/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation
import Moya

enum MovieAPI {
    case getPopularMovies(page: Int)
}

let APIKey = "29d7a305994684a8d4d06303fcd07a4d"
let language = "en-US"

extension MovieAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .getPopularMovies(let page):
            return "/movie/popular?api_key=\(APIKey)&language=\(language)&page=\(page)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getPopularMovies(_):
            return .get
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var task: Task {
        switch self {
        case .getPopularMovies(_):
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
