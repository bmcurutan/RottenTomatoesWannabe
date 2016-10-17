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
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let posterPath = movie.posterPath {
            let posterUrl = NSURL(string: Constants.baseUrl + posterPath)
            self.posterImageView.setImageWith(posterUrl as! URL, placeholderImage: UIImage(named: "no_poster"))
        }
    }
    
    @IBAction func closePhotoModal(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
