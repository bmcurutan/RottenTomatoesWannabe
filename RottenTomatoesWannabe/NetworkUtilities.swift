//
//  NetworkUtilities.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/14/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import MBProgressHUD
import UIKit

class NetworkUtilities {
    
    // Singleton instance
    static let sharedInstance = NetworkUtilities()
    
    func fetchDataWithUrl(url: String, completion: @escaping ([Movie]) -> Void, errorCallback: ((NSError?) -> Void)?) {
        let url = URL(string:url)
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, responseOrNil, errorOrNil) in
            if let requestError = errorOrNil {
                errorCallback?(requestError as NSError?)
            } else {
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        var json: [Movie] = []
                        for dict in responseDictionary["results"] as! [NSDictionary] {
                            let movie = Movie()
                            if let id = dict["id"] as? Int {
                                movie.id = id
                            }
                            if let posterPath = dict["poster_path"] as? String {
                                movie.posterPath = posterPath
                            }
                            if let releaseDate = dict["release_date"] as? String {
                                movie.releaseDate = releaseDate
                            }
                            if let overview = dict["overview"] as? String {
                                movie.overview = overview
                            }
                            if let title = dict["title"] as? String {
                                movie.title = title
                            }
                            if let voteAverage = dict["vote_average"] as? Double {
                                movie.voteAverage = voteAverage
                            }
                            if let voteCount = dict["vote_count"] as? Int {
                                movie.voteCount = voteCount
                            }
                            
                            json.append(movie)
                        }
                        completion(json)
                    }
                }
            }
        });
        task.resume()
    }
}
