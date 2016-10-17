//
//  Movie.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/14/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import Foundation

class Movie {
    
    var id:Int
    var posterPath:String
    var releaseDate:Date
    var overview:String
    var title:String
    
    init(id: Int, posterPath: String, releaseDate: Date, overview: String, title: String) {
        self.id = id
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.overview = overview
        self.title = title
    }

    
}
