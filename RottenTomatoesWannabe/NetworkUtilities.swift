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
    
    func fetchDataWithUrl(url: String, completion: @escaping ([NSDictionary]) -> Void) {
        let url = URL(string:url)
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        //MBProgressHUD.showAdded(to: self.view, animated: true)
        
        let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    //MBProgressHUD.hide(for: self.view, animated: true)
                    
                    /*self.movies = responseDictionary["results"] as? [NSDictionary]
                    self.searchData = self.movies
                    self.moviesTableView.reloadData()*/
                    completion(responseDictionary["results"] as! [NSDictionary])
                }
            }
        });
        task.resume()
    }
}
