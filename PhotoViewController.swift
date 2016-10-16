//
//  PhotoViewController.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/15/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let baseUrl = "https://image.tmdb.org/t/p/w342";
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            self.posterImageView.setImageWith(posterUrl as! URL)
        }
    }
    
    @IBAction func closePhotoModal(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
