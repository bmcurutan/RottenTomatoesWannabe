//
//  Movie.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/14/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import Foundation

class Movie {
    
    var id:Int?
    var posterPath:String?
    var posterPathSmall:String?
    var releaseDate:String?
    var overview:String?
    var title:String?
    var voteAverage:Double?
    var voteCount:Int?
    
    init() {
        // Empty movie
    }
    
    init(id:Int, posterPath:String, posterPathSmall:String, releaseDate:String, overview:String, title:String, voteAverage:Double, voteCount:Int) {
        self.id = id
        self.posterPath = posterPath
        self.posterPathSmall = posterPathSmall
        self.releaseDate = releaseDate
        self.overview = overview
        self.title = title
        self.voteAverage = voteAverage
        self.voteCount = voteCount
    }

    
}
