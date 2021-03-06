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
    
    var movie: Movie!
    var poster: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let posterPath = movie.posterPath {
            let smallPosterUrl = NSURL(string: Constants.baseUrl + Constants.smallSize + posterPath) // low res image
            let posterUrl = NSURL(string: Constants.baseUrl + Constants.normalSize + posterPath) // normal res image
            let largePosterUrl = NSURL(string: Constants.baseUrl + Constants.largeSize + posterPath) // HD image
            let smallImageRequest = NSURLRequest(url: smallPosterUrl as! URL)
            let imageRequest = NSURLRequest(url: posterUrl as! URL)
            let largeImageRequest = NSURLRequest(url: largePosterUrl as! URL)
            
            self.posterImageView.setImageWith(
                smallImageRequest as URLRequest,
                placeholderImage: UIImage(named:"no poster"),
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                 
                    // Default to low res image
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;
                    self.poster = smallImage
                    
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        self.posterImageView.alpha = 1.0
                        }, completion: { (success) -> Void in
                            self.posterImageView.setImageWith(largeImageRequest as URLRequest, placeholderImage: smallImage, success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    // Show HD image if available
                                    self.posterImageView.image = largeImage;
                                    self.poster = largeImage
                                },
                                
                                failure: { (request, response, error) -> Void in
                                    self.posterImageView.setImageWith(
                                        imageRequest as URLRequest,
                                        placeholderImage: smallImage,
                                        success: { (imageRequest, imageResponse, image) -> Void in
                                            // Display normal res image if HD image fetch fails
                                            self.posterImageView.image = image;
                                            self.poster = image
                                        },
                                        
                                        failure: { (request, response, error) -> Void in
                                            // Print error - only the placeholder image is available in the meantime
                                            print("Error: \(error.localizedDescription)")
                                    })
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    self.posterImageView.setImageWith(largeImageRequest as URLRequest, placeholderImage: UIImage(named:"no_poster"), success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            // Display the HD image immediately if the low res image fails and if the HD image is available
                            self.posterImageView.image = largeImage;
                            self.poster = largeImage
                        },
                                                      
                        failure: { (request, response, error) -> Void in
                            self.posterImageView.setImageWith(
                                imageRequest as URLRequest,
                                placeholderImage: UIImage(named:"no_poster"),
                                success: { (imageRequest, imageResponse, image) -> Void in
                                    // Otherwise display the normal res image
                                    self.posterImageView.image = image;
                                    self.poster = image
                                },
                                failure: { (request, response, error) -> Void in
                                    // Print error - only the placeholder image is available in the meantime
                                    print("Error: \(error.localizedDescription)")
                            })
                    })
            })
            
        } else {
        self.posterImageView.frame = CGRect(x:0, y:0, width:0, height:0)
            self.infoView.frame = CGRect(x:0, y:0, width:self.infoView.frame.size.width, height:self.infoView.frame.size.height)
            self.posterButton.isEnabled = false
        }
        
        let title = movie.title
        self.title = title // Navigation bar title
        self.titleLabel.text = title
        self.titleLabel.sizeToFit()
        
        if let count = movie.voteCount,
           let voteAverage = movie.voteAverage {
            if count > 0 {
                self.ratingLabel.text = "Rating: \(String(voteAverage))"
                self.ratingLabel.sizeToFit()
            }
        }
        
        if let releaseDate = movie.releaseDate {
            self.releaseDateLabel.text = releaseDate
        }
        
        if let overview = movie.overview {
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
            photoViewController.poster = self.poster
    }
}
