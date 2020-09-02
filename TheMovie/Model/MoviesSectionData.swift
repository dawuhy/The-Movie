//
//  SectionDataSource.swift
//  TheMovie
//
//  Created by Huy on 8/25/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation
import UIKit

class MoviesSectionData {
    private var movieService:MovieServiceType = MovieService()
    var title: String
    var movieType:MovieType
    var arrayMovie:[Movie]
    
    init(movieType: MovieType, arrayMovie:[Movie]) {
        self.title = movieType.title()
        self.movieType = movieType
        self.arrayMovie = arrayMovie
    }
}
