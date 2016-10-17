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
            let smallPosterUrl = NSURL(string: Constants.baseUrl + Constants.smallSize + posterPath)
            let posterUrl = NSURL(string: Constants.baseUrl + Constants.normalSize + posterPath)
            let largePosterUrl = NSURL(string: Constants.baseUrl + Constants.largeSize + posterPath)
            let smallImageRequest = NSURLRequest(url: smallPosterUrl as! URL)
            let imageRequest = NSURLRequest(url: posterUrl as! URL)
            let largeImageRequest = NSURLRequest(url: largePosterUrl as! URL)
            
            self.posterImageView.setImageWith(
                smallImageRequest as URLRequest,
                placeholderImage: UIImage(named:"no poster"),
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    
                    // smallImageResponse will be nil if the smallImage is already available in cache
                    self.posterImageView.alpha = 0.0
                    self.posterImageView.image = smallImage;
                    
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        self.posterImageView.alpha = 1.0
                        }, completion: { (success) -> Void in
                            self.posterImageView.setImageWith(
                                largeImageRequest as URLRequest,
                                placeholderImage: smallImage,
                                success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    self.posterImageView.image = largeImage;
                                },
                                failure: { (request, response, error) -> Void in
                                    self.posterImageView.setImageWith(
                                        imageRequest as URLRequest,
                                        placeholderImage: smallImage,
                                        success: { (imageRequest, imageResponse, image) -> Void in
                                            self.posterImageView.image = image;
                                        },
                                        failure: { (request, response, error) -> Void in
                                            print("Error: \(error.localizedDescription)")
                                    })
                            })
                    })
                },
                failure: { (request, response, error) -> Void in
                    self.posterImageView.setImageWith(
                        largeImageRequest as URLRequest,
                        placeholderImage: UIImage(named:"no_poster"),
                        success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            self.posterImageView.image = largeImage;
                        },
                        failure: { (request, response, error) -> Void in
                            self.posterImageView.setImageWith(
                                imageRequest as URLRequest,
                                placeholderImage: UIImage(named:"no_poster"),
                                success: { (imageRequest, imageResponse, image) -> Void in
                                    self.posterImageView.image = image;
                                },
                                failure: { (request, response, error) -> Void in
                                    print("Error: \(error.localizedDescription)")
                            })
                    })
            })
        }
    }
    
    @IBAction func closePhotoModal(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
