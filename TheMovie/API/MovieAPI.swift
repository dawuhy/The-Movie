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
    case getMovies(page: Int, type: MovieType)
    case getMovieTrailer(movieId: Int)
    case getTrendingMovies
    case searchMovie(movieName:String)
    case getSimilarMovies(movieId: Int, page:Int)
    case searchPeople(name: String)
}

extension MovieAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.themoviedb.org/3")!
    }
    
    var path: String {
        switch self {
        case .getMovies(_, let type):
            return "/movie/\(type)"
        case .getMovieTrailer(let movieId):
            return "/movie/\(movieId)/videos"
        case .getTrendingMovies:
            return "/trending/movie/day"
        case .searchMovie:
            return "/search/movie"
        case .getSimilarMovies(movieId: let movieId, page: _):
            return "/movie/\(movieId)/similar"
        case .searchPeople:
            return "/search/person"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getMovies:
            return .get
        case .getMovieTrailer:
            return .get
        case .getTrendingMovies:
            return .get
        case .searchMovie:
            return .get
        case .getSimilarMovies:
            return .get
        case .searchPeople:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getMovies(let page, _):
            return .requestParameters(parameters: [ "page": "\(page)"], encoding: URLEncoding.default)
        case .getMovieTrailer:
            return .requestParameters(parameters: ["": ""], encoding: URLEncoding.default)
        case .getTrendingMovies:
            return .requestParameters(parameters: ["": ""], encoding: URLEncoding.default)
        case .searchMovie(movieName: let movieName):
            return .requestParameters(parameters: ["query": "\(movieName)"], encoding: URLEncoding.default)
        case .getSimilarMovies(movieId: let movieId, page: let page):
            return .requestParameters(parameters: ["movie_id": "\(movieId)", "page": "\(page)"], encoding: URLEncoding.default)
        case .searchPeople(name: let name):
            return .requestParameters(parameters: ["query": "\(name)"], encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
    }
    
    var headers: [String : String]? {
        return ["Content-Typer": "application/json"]
    }
}
