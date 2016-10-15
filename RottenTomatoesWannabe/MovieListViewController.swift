//
//  MovieListViewController.swift
//  RottenTomatoesWannabe
//
//  Created by Bianca Curutan on 10/13/16.
//  Copyright © 2016 Bianca Curutan. All rights reserved.
//

import AFNetworking
import MBProgressHUD
import ReachabilitySwift
import UIKit

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var movies: [NSDictionary]?
    var typeEndpoint: String?
    var typeTitle: String?
    var reachability: Reachability = Reachability()!
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkForNetwork()
    }
    
    func checkForNetwork() {
        if reachability.isReachable {
            self.errorView.isHidden = true // Hide Network Error message
        } else {
            self.errorView.isHidden = false// Display Network Error message
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = typeTitle
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.moviesTableView.insertSubview(refreshControl, at: 0)
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        if let endpoint = typeEndpoint {
            let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
            let request = URLRequest(url: url!)
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.moviesTableView.reloadData()
                    }
                }
            });
            task.resume()
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.checkForNetwork()
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        if let endpoint = typeEndpoint {
            let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
            let request = URLRequest(url: url!)

            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.moviesTableView.reloadData()
                refreshControl.endRefreshing()	
            });
            task.resume()
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.movies {
            return movies.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell") as! MovieCell
        if let movies = self.movies {
            let movie = movies[indexPath.row]
            
            let title = movie["original_title"] as! String
            let overview = movie["overview"] as! String
            cell.titleLabel.text = title
            cell.overviewLabel.text = overview
            
            let baseUrl = "https://image.tmdb.org/t/p/w342";
            if let posterPath = movie["poster_path"] as? String {
                let posterUrl = NSURL(string: baseUrl + posterPath)
                cell.posterImageView.setImageWith(posterUrl as! URL)
            }
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = self.moviesTableView.indexPath(for: cell)
        if let movies = self.movies {
            let movie = movies[indexPath!.row]
            let detailViewController = segue.destination as! MovieDetailsViewController
            detailViewController.movie = movie
        }
    }
}
