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
    @IBOutlet weak var posterButton: UIButton!
    @IBOutlet weak var infoView: UIView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: Constants.baseUrl + posterPath)
            self.posterImageView.setImageWith(posterUrl as! URL)
        } else {
        self.posterImageView.frame = CGRect(x:0, y:0, width:0, height:0)
            self.infoView.frame = CGRect(x:0, y:0, width:self.infoView.frame.size.width, height:self.infoView.frame.size.height)
            self.posterButton.isEnabled = false
        }
        
        let title = movie["original_title"] as! String
        self.title = title // Navigation bar title
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
        
        let rating = movie["vote_average"] as! Double
        if let count = movie["vote_count"] as? Int {
            if count > 0 {
                self.ratingLabel.text = "Rating: \(String(rating))"
                self.ratingLabel.sizeToFit()
            }
        }
        
        let releaseDate = movie["release_date"] as! String
        self.releaseDateLabel.text = releaseDate
        
        if let overview = movie["overview"] as? String {
            self.overviewLabel.text = "Synopsis: \(overview)"
        }
        self.overviewLabel.sizeToFit()
        
        // Move and resize labels if needed
        let padding = 8.0
        var currentY = padding + Double(self.titleLabel.frame.size.height) + padding
        self.ratingLabel.frame.origin = CGPoint(x:Double(self.ratingLabel.frame.origin.x), y:currentY)
        self.releaseDateLabel.frame.origin = CGPoint(x:Double(self.releaseDateLabel.frame.origin.x), y:currentY)
        currentY += Double(self.ratingLabel.frame.size.height) + padding
        self.overviewLabel.frame.origin = CGPoint(x:Double(self.overviewLabel.frame.origin.x), y:currentY)
        
        let viewHeight = currentY + Double(self.overviewLabel.frame.size.height) + padding
        self.infoView.frame.size = CGSize(width:Double(self.infoView.frame.size.width), height:viewHeight)
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: self.infoView.frame.origin.y + self.infoView.frame.size.height)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let photoViewController = segue.destination as! PhotoViewController
            photoViewController.movie = movie
    }
}
