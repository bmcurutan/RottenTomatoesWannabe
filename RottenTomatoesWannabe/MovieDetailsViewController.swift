//
//  MovieDetailsViewController.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/14/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.infoView.frame.origin.y + self.infoView.frame.size.height)

        let title = movie["original_title"] as! String
        let rating = movie["vote_average"] as! Double
        let releaseDate = movie["release_date"] as! String // TODO, long date format
        let overview = movie["overview"] as! String
        
        self.title = title
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
        
        if let count = movie["vote_count"] as? Int {
            if count > 0 {
                //self.ratingLabel.text = "Rating: \(String(rating))"
                self.ratingLabel.sizeToFit()
            }
        }
        
        self.releaseDateLabel.text = releaseDate
        self.overviewLabel.text = "Synopsis: \(overview)"
        self.overviewLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w342";
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            self.posterImageView.setImageWith(posterUrl as! URL)
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photoViewController = segue.destination as! PhotoViewController
            photoViewController.movie = movie
    }
}
