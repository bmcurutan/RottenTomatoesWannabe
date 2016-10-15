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
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = movie["original_title"] as! String
        let overview = movie["overview"] as! String
        self.titleLabel.text = title
        self.overviewLabel.text = overview
        
        let baseUrl = "https://image.tmdb.org/t/p/w342";
        if let posterPath = movie["poster_path"] as? String {
            let posterUrl = NSURL(string: baseUrl + posterPath)
            self.posterImageView.setImageWith(posterUrl as! URL)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
