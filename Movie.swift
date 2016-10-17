//
//  Movie.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/14/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import ObjectMapper
import UIKit

struct Movie: Mappable {
    
    var id:Int?
    var posterPath:String?
    var releaseDate:Date?
    var overview:String?
    var title:String?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        self.id          <- map["id"]
        self.posterPath  <- map["poster_path"]
        self.releaseDate <- map["release_date"]
        self.overview    <- map["overview"]
        self.title       <- map["original_title"]
    }
    
}
