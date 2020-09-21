//
//  RealmService.swift
//  TheMovie
//
//  Created by Huy on 8/20/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation
import RealmSwift

protocol LocalDBServiceType {
    func addMovie(movie: Movie)
    func loadData()
    func printPath()
    func deleteMovie(movie: Movie)
    func addObserver(completion: @escaping (Result<Results<FavoriteMovie>, Error>) -> Void)
}

class RealmService: LocalDBServiceType {
    var realm:Realm
    var notificationToken: NotificationToken?
    
    init() {
        realm = try! Realm()
    }
    
    func printPath() {
        print(realm.configuration.fileURL!)
    }
    
    func addMovie(movie: Movie) {
        let movieObject = FavoriteMovie()
        movieObject.loadFrom(movie: movie)
        try! self.realm.write {
            self.realm.add(movieObject)
            loadData()
        }
        print("Added id: \(movie.id), total: \(listFavoriteMovieId.count)")
    }
    
    func loadData() {
        listFavoriteMovie = realm.objects(FavoriteMovie.self)
    }
    
    func deleteMovie(movie: Movie) {
        try! self.realm.write {
            self.realm.delete(listFavoriteMovie.filter { $0.id == movie.id })
            loadData()
        }
        print("Remove id: \(movie.id), total: \(listFavoriteMovieId.count)")
    }
    
    func addObserver(completion: @escaping (Result<Results<FavoriteMovie>, Error>) -> Void) {
        notificationToken = listFavoriteMovie.observe() { changes in
            switch changes {
            case .initial(let movies):
                print("Initial favorite movies: \(movies.count)")
                completion(.success(listFavoriteMovie))
            case .update(let movies, let deletions, let insertions, let modifications):
                print("Update case \(movies.count)")
                print(deletions)
                print(insertions)
                print(modifications)
                completion(.success(listFavoriteMovie))
                return
            case .error(let error):
                completion(.failure(error))
                return
            }
        }
    }
}
