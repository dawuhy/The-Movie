//
//  MovieObject.swift
//  TheMovie
//
//  Created by Huy on 8/14/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import RealmSwift

class MovieObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var posterPath:String = ""
    @objc dynamic var backdropPath:String?
    @objc dynamic var releaseDate:String = ""
    @objc dynamic var rating:Float = 0
    @objc dynamic var overview:String = ""
    
    func loadFrom(movie:Movie) {
        id = movie.id
        backdropPath = movie.backdropPath
        overview = movie.overview
        posterPath = movie.posterPath ?? "https://media.sproutsocial.com/uploads/2017/02/10x-featured-social-media-image-size.png"
        rating = movie.rating
        releaseDate = movie.releaseDate!
        title = movie.title!
    }
}
