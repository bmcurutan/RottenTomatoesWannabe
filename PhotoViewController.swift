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
            let smallPosterUrl = NSURL(string: Constants.baseUrl + Constants.smallSize + posterPath) // low res image
            let posterUrl = NSURL(string: Constants.baseUrl + Constants.normalSize + posterPath) // normal res image
            let largePosterUrl = NSURL(string: Constants.baseUrl + Constants.largeSize + posterPath) // HD image
            let smallImageRequest = NSURLRequest(url: smallPosterUrl as! URL)
            let imageRequest = NSURLRequest(url: posterUrl as! URL)
            let largeImageRequest = NSURLRequest(url: largePosterUrl as! URL)
            
            self.posterImageView.setImageWith(
                smallImageRequest as URLRequest, placeholderImage: UIImage(named:"no_poster"), success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // Default to low res image
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;
                    
                    UIView.animate(withDuration: 0.5, animations: { () -> Void in
                        self.posterImageView.alpha = 1.0
                        }, completion: { (success) -> Void in
                            self.posterImageView.setImageWith(largeImageRequest as URLRequest, placeholderImage: smallImage, success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    // Show HD image if available
                                    self.posterImageView.image = largeImage;
                                },
                                                              
                                failure: { (request, response, error) -> Void in
                                    self.posterImageView.setImageWith(
                                        imageRequest as URLRequest,
                                        placeholderImage: smallImage,
                                        success: { (imageRequest, imageResponse, image) -> Void in
                                            // Display normal res image if HD image fetch fails
                                            self.posterImageView.image = image;
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
                        },
                                                      
                        failure: { (request, response, error) -> Void in
                            self.posterImageView.setImageWith(
                                imageRequest as URLRequest,
                                placeholderImage: UIImage(named:"no_poster"),
                                success: { (imageRequest, imageResponse, image) -> Void in
                                    // Otherwise display the normal res image
                                    self.posterImageView.image = image;
                                },
                                
                                failure: { (request, response, error) -> Void in
                                    // Print error - only the placeholder image is available in the meantime
                                    print("Error: \(error.localizedDescription)")
                            })
                    })
            })
        }
    }
    
    // Close zoomed in poster image modal
    @IBAction func closePhotoModal(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
