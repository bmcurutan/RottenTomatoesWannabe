//
//  MovieListViewController.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/13/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class MovieListViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var moviesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moviesTableView.rowHeight = 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exampleCell") as! MyCell
        cell.myCustomlabel.text = "Row \(indexPath.row)"
        return cell
    }
}

class MyCell: UITableViewCell {
    @IBOutlet weak var myCustomlabel: UILabel!
}
