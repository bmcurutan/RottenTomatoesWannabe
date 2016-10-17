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

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, /*UIViewControllerPreviewingDelegate,*/ UISearchBarDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var movies: [Movie]? // List of movie data
    var searchData: [Movie]? // List of filtered movie data
    
    var typeEndpoint: String? // now_playing, top_rated, upcoming
    var typeTitle: String? // Now Playing, Top Rated, Upcoming
    
    var reachability: Reachability = Reachability()! // Used to check network connection
    
    var isMoreDataLoading = false // More data loading status
    var page: Int = 1 // API page number for movies list
    var loadingView: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkForNetwork()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = typeTitle
        
        // Search Bar
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.tintColor = UIColor.black
        searchBar.placeholder = "Search movies"
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // 3D Touch
        /*if (traitCollection.forceTouchCapability == .available) {
            registerForPreviewing(with: self, sourceView: view)
        }*/
        
        // Pull to Refresh refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.moviesTableView.insertSubview(refreshControl, at: 0)
        
        // Infinite Scrolling loading icon
        let tableFooterView: UIView = UIView(frame: CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:50))
        loadingView.center = tableFooterView.center
        tableFooterView.addSubview(loadingView)
        self.moviesTableView.tableFooterView = tableFooterView
        
        if let endpoint = typeEndpoint {
            let urlString = "\(Constants.movieDbUrl)movie/\(endpoint)?api_key=\(Constants.apiKey)"
            MBProgressHUD.showAdded(to: self.view, animated: true)
            NetworkUtilities.sharedInstance.fetchDataWithUrl(url:urlString, completion: { (json) -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.movies = json
                self.searchData = self.movies
                self.moviesTableView.reloadData()
            })
        }
    }
    
    // MARK: - Private Methods
    
    func checkForNetwork() {
        if reachability.isReachable {
            self.errorView.isHidden = true // Hide Network Error message
        } else {
            self.errorView.isHidden = false// Display Network Error message
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.checkForNetwork()
        if let endpoint = typeEndpoint {
            let urlString = "\(Constants.movieDbUrl)movie/\(endpoint)?api_key=\(Constants.apiKey)"
            NetworkUtilities.sharedInstance.fetchDataWithUrl(url:urlString, completion: { (json) -> Void in
                self.movies = json
                self.searchData = self.movies
                self.moviesTableView.reloadData()
                refreshControl.endRefreshing()
            })
        }
    }
    
    func loadMoreData() {
        // Increment page
        page += 1
        
        if let endpoint = typeEndpoint {
            let urlString = "\(Constants.movieDbUrl)movie/\(endpoint)?api_key=\(Constants.apiKey)&page=\(page)"
            NetworkUtilities.sharedInstance.fetchDataWithUrl(url:urlString, completion: { (json) -> Void in
                self.isMoreDataLoading = false
                self.loadingView.stopAnimating()
                for dict in json {
                    self.movies?.append(dict)
                    self.searchData = self.movies
                }
                self.moviesTableView.reloadData()
            })
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let searchData = self.searchData {
            return searchData.count
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"movieCell") as! MovieCell

        // Cell selection style
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red:0.34, green:0.41, blue:0.18, alpha:0.5)
        cell.selectedBackgroundView = backgroundView
        
        if let movies = self.searchData {
            let movie = movies[indexPath.row]
            
            let title = movie.title
            cell.titleLabel.text = title
            
            if let overview = movie.overview {
                cell.overviewLabel.text = "Synopsis: \(overview)"
            }
            
            if let posterPath = movie.posterPath {
                let posterUrl = NSURL(string: Constants.baseUrl + posterPath)
                cell.posterImageView.setImageWith(posterUrl as! URL)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.moviesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    /*func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = self.moviesTableView?.indexPathForRow(at: CGPoint(x:location.x, y:location.y-64)) {
            if let cell = self.moviesTableView?.cellForRow(at: indexPath) {
                previewingContext.sourceRect = CGRect(x:cell.frame.origin.x, y:cell.frame.origin.y+64, width: cell.frame.size.width, height:cell.frame.size.height)
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                if let movies = self.searchData {
                    let movie = movies[indexPath.row]
                    let detailViewController = storyboard.instantiateViewController(withIdentifier: "movieDetailsViewController") as! MovieDetailsViewController
                    detailViewController.movie = movie
                    return detailViewController
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
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = self.moviesTableView.indexPath(for: cell)
        if let movies = self.searchData {
            let movie = movies[indexPath!.row]
            let detailViewController = segue.destination as! MovieDetailsViewController
            detailViewController.movie = movie
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.searchData = self.movies
            self.moviesTableView.reloadData()
        } else {
            let urlString = "\(Constants.movieDbUrl)search/movie?api_key=\(Constants.apiKey)&query=\(searchText)"
            NetworkUtilities.sharedInstance.fetchDataWithUrl(url:urlString, completion: { (json) -> Void in
                self.searchData = json
                self.moviesTableView.reloadData()
            })
        }
    }
}
