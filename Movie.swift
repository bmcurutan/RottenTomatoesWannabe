//
//  Movie.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/14/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class Movie {
    
    var id: Int?
    var posterPath: String?
    var releaseDate: String? // 2016-10-17
    var overview: String?
    var title: String?
    var voteAverage: Double? // 4.58
    var voteCount: Int? // 2
    
    init() {
        // Empty movie
    }
}
