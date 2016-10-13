//
//  ViewController.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/13/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "") 
        cell.textLabel?.text = "Row \(indexPath.row)"
        return cell
    }
}

