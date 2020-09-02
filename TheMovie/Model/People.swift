//
//  People.swift
//  TheMovie
//
//  Created by Huy on 9/1/20.
//  Copyright © 2020 nhn. All rights reserved.
//

import Foundation

struct People: Decodable {
    var popularity:Double
    var knownForDepartment:String
    var name:String
    var id:Int
    var profilePath:String?
    var adult:Bool
    var knownFor:[Movie]?

    enum CodingKeys: String, CodingKey {
        case popularity
        case knownForDepartment = "known_for_department"
        case name
        case id
        case profilePath = "profile_path"
        case adult
        case knownFor = "known_for"
    }
}
