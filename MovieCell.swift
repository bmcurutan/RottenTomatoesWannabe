//
//  MovieCell.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/14/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

// Used in MovieListViewController
class MovieCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Customize cell selection style
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.34, green:0.41, blue:0.18, alpha:0.5)
        self.selectedBackgroundView = backgroundView
    }
    
}
