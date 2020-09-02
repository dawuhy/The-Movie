//
//  MovieService.swift
//  TheMovie
//
//  Created by Huy on 8/10/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation
import Moya

protocol MovieServiceType {
    
    func getMovies(page: Int, type: MovieType, completion: @escaping (Result<MovieResult, Error>) -> Void)
    func getKeyMovieTrailer(movieId: Int, completion: @escaping (Result<MovieTrailerResult, Error>) -> Void)
    func getTrendingMovie(completion: @escaping (Result<MovieResult, Error>) -> Void)
    func searchMovie(movieName:String, completion: @escaping (Result<MovieResult, Error>) -> Void)
    func getSimilarMovie(movieId: Int, page:Int, completion: @escaping (Result<MovieResult, Error>) -> Void)
    func searchPeople(peopleName: String, completion: @escaping (Result<PeopleResult, Error>) -> Void)
}

class MovieService: MovieServiceType {
    
    var movieProvider: MoyaProvider<MovieAPI>
    
    init() {
        self.movieProvider = MoyaProvider<MovieAPI>(endpointClosure: { (target: TargetType) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: MultiTarget(target))
            switch defaultEndpoint.task {
            case .requestParameters(var params, let encoding):
                params["api_key"] = APIKey // this parameter should be passed to every request
                params["language"] = "en-US"
                return Endpoint(url: defaultEndpoint.url, sampleResponseClosure: defaultEndpoint.sampleResponseClosure, method: defaultEndpoint.method, task: .requestParameters(parameters: params, encoding: encoding), httpHeaderFields: defaultEndpoint.httpHeaderFields)
            default:
                break
            }
            return defaultEndpoint
        })
    }
    
    func getMovies(page: Int, type: MovieType, completion: @escaping (Result<MovieResult, Error>) -> Void) {
        movieProvider.request(.getMovies(page: page, type: type)) { (result) in
            switch result {
            case .success(let res):
                do {
                    let movieResult = try JSONDecoder().decode(MovieResult.self, from: res.data)
                    completion(.success(movieResult))
                    return
                    
                } catch (let error) {
                    print("ERROR REQUEST: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
            case .failure(let error):
                completion(.failure(error))
                return
            }
        }
    }
    
    func getKeyMovieTrailer(movieId: Int, completion: @escaping (Result<MovieTrailerResult, Error>) -> Void) {
        movieProvider.request(.getMovieTrailer(movieId: movieId)) { (result) in
            switch result {
            case .success(let response):
                do {
                    // print(res.request?.urlRequest?.url?.absoluteString)
                    let response = try JSONDecoder().decode(MovieTrailerResult.self, from: response.data)
                    completion(.success(response))
                } catch (let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTrendingMovie(completion: @escaping (Result<MovieResult, Error>) -> Void) {
        movieProvider.request(.getTrendingMovies) { (result) in
            switch result {
            case .success(let response):
                do {
                    let movieResponse = try JSONDecoder().decode(MovieResult.self, from: response.data)
                    completion(.success(movieResponse))
                } catch (let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSimilarMovie(movieId: Int, page:Int, completion: @escaping (Result<MovieResult, Error>) -> Void) {
        movieProvider.request(.getSimilarMovies(movieId: movieId, page: page)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let movieResponse = try JSONDecoder().decode(MovieResult.self, from: response.data)
                    completion(.success(movieResponse))
                } catch (let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchMovie(movieName: String, completion: @escaping (Result<MovieResult, Error>) -> Void) {
        movieProvider.request(.searchMovie(movieName: movieName)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let movieResponse = try JSONDecoder().decode(MovieResult.self, from: response.data)
                    completion(.success(movieResponse))
                } catch (let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchPeople(peopleName: String, completion: @escaping (Result<PeopleResult, Error>) -> Void) {
        movieProvider.request(.searchPeople(name: peopleName)) { (result) in
            switch result {
            case .success(let response):
                do {
                    let peopleResponse = try JSONDecoder().decode(PeopleResult.self, from: response.data)
                    completion(.success(peopleResponse))
                } catch (let error) {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
