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
    
    var poster: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.posterImageView.image = poster
    }
    
    // Close zoomed in poster image modal
    @IBAction func closePhotoModal(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
