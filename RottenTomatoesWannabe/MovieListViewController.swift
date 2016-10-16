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

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate /*, UIViewControllerPreviewingDelegate*/ {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var movies: [NSDictionary]?
    var typeEndpoint: String?
    var typeTitle: String?
    var reachability: Reachability = Reachability()!
    var isMoreDataLoading = false
    var page: Int = 1
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
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
        
        /*if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: view)
        }*/
        
        // Pull to Refresh refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.moviesTableView.insertSubview(refreshControl, at: 0)
        
        // Infinite Loading loading icon
        let tableFooterView: UIView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:50))
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.moviesTableView.tableFooterView = tableFooterView
        
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
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        MBProgressHUD.hide(for: self.view, animated: true)
                        
                        self.movies = responseDictionary["results"] as? [NSDictionary]
                        self.moviesTableView.reloadData()
                        refreshControl.endRefreshing()
                    }
                }
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
        let cell = tableView.dequeueReusableCell(withIdentifier:"movieCell") as! MovieCell

        // Cell selection style
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.34, green:0.41, blue:0.18, alpha:0.5)
        cell.selectedBackgroundView = backgroundView
        
        if let movies = self.movies {
            let movie = movies[indexPath.row]
            
            let title = movie["original_title"] as! String
            let overview = movie["overview"] as! String
            cell.titleLabel.text = title
            cell.overviewLabel.text = "Synopsis: \(overview)"
            
            let baseUrl = "https://image.tmdb.org/t/p/w342";
            if let posterPath = movie["poster_path"] as? String {
                let posterUrl = NSURL(string: baseUrl + posterPath)
                cell.posterImageView.setImageWith(posterUrl as! URL)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.moviesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = self.moviesTableView?.indexPathForRow(at: location) {
            if let cell = self.moviesTableView?.cellForRow(at: indexPath) {
                previewingContext.sourceRect = cell.frame
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let movieDetailsViewController = storyboard.instantiateViewController(withIdentifier: "movieDetailsViewController") as? MovieDetailsViewController {
                    return movieDetailsViewController
                }
                
            }
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }*/
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = self.moviesTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.moviesTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.moviesTableView.isDragging) {
                loadingView.startAnimating()
                isMoreDataLoading = true
                loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        // Increment page
        page += 1
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        if let endpoint = typeEndpoint {
            let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)&page=\(page)")
            let request = URLRequest(url: url!)
            
            // Configure session so that completion handler is executed on main UI thread
            let session = URLSession(
                configuration: URLSessionConfiguration.default,
                delegate:nil,
                delegateQueue:OperationQueue.main
            )
        
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        // Update flag
                        self.isMoreDataLoading = false
                        
                        // Stop the loading indicator
                        self.loadingView.stopAnimating()
                        
                        // Use the new data to update the data source
                        for dict in responseDictionary["results"] as! [NSDictionary] {
                            self.movies?.append(dict)
                        }
                        
                        // Reload the tableView now that there is new data
                        self.moviesTableView.reloadData()
                    }
                }
            });
            task.resume()
        }
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
