//
//  Utils.swift
//  TheMovie
//
//  Created by Huy on 8/3/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation
import RealmSwift

var listFavoriteMovieId:[Any] = []
var listFavoriteMovie: Results<FavoriteMovie>!
var noti: NotificationToken?
let widthOfCells:CGFloat = 200
let heightOfCells:CGFloat = widthOfCells * 1.5
let APIKey = "29d7a305994684a8d4d06303fcd07a4d"

enum MovieType {
    case now_playing
    case popular
    case top_rated
    case similar
    
    func title() -> String {
        switch self {
        case .now_playing:
            return "Now playing"
        case .popular:
            return "Popular"
        case .top_rated:
            return "Top rated"
        case .similar:
            return "Similar movies"
        }
    }
}

enum SearchType {
    case movie
    case people
//    case tvshow
  
}

// MARK: - Child view controller
extension UIViewController {
    func add(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}

func getStringURLImage(path: String) -> String {
    return "https://image.tmdb.org/t/p/original\(path)"
}
