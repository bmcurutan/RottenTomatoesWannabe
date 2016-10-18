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

class MovieListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var moviesTableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    var movies: [Movie]? // List of movie data
    var filteredMovies: [Movie]? // List of filtered movie data
    
    var typeEndpoint: String? // now_playing, top_rated, upcoming
    var typeTitle: String? // Now Playing, Top Rated, Upcoming
    
    var reachability: Reachability = Reachability()! // Used to check network connection
    
    var isLoading = false // Status to know if more movies are being loaded or not
    var page: Int = 1 // Movie DB API page number for movies list
    var loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNetworkError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = typeTitle
        
        // Reachability
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Error: Could not start reachability notifier")
        }
        
        // Search Bar setup
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.tintColor = UIColor.black
        searchBar.placeholder = "Search movies"
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        // Pull to Refresh refresh control
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        self.moviesTableView.insertSubview(refreshControl, at: 0)
        
        // Infinite Scrolling loading icon
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 50))
        loadingIndicator.center = footerView.center
        footerView.addSubview(self.loadingIndicator)
        self.moviesTableView.tableFooterView = footerView
        
        // Fetch the movie data
        if let endpoint = typeEndpoint {
            let urlString = "\(Constants.movieDbUrl)movie/\(endpoint)?api_key=\(Constants.apiKey)"
            MBProgressHUD.showAdded(to: self.view, animated: true)
            NetworkUtilities.sharedInstance.fetchDataWithUrl(url:urlString, successCallback: { (json) -> Void in
                MBProgressHUD.hide(for: self.view, animated: true)
                self.movies = json
                self.filteredMovies = self.movies
                self.moviesTableView.reloadData()
                
                }, errorCallback: { (error) -> Void in
                    print("Error: \(error?.description)")
            })
        }
    }
    
    // MARK: - Private Methods
    
    func updateNetworkError() {
        if reachability.isReachable {
            self.errorView.isHidden = true // Hide Network Error message
        } else {
            self.errorView.isHidden = false// Display Network Error message
        }
    }
    
    // Automatically hide/display network error message without additional user interaction needed
    func reachabilityChanged(notification: NSNotification) {
        let reachability = notification.object as! Reachability
        if reachability.isReachable {
            self.errorView.isHidden = true // Hide Network Error message
        } else {
            self.errorView.isHidden = false // Display Network Error message
        }
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        updateNetworkError()
        
        // Refresh the movie data
        if let endpoint = typeEndpoint {
            let urlString = "\(Constants.movieDbUrl)movie/\(endpoint)?api_key=\(Constants.apiKey)"
            NetworkUtilities.sharedInstance.fetchDataWithUrl(url:urlString, successCallback: { (json) -> Void in
                self.movies = json
                self.filteredMovies = self.movies
                self.moviesTableView.reloadData()
                refreshControl.endRefreshing()
                
                }, errorCallback: { (error) -> Void in
                    print("Error: \(error?.description)")
            })
        }
    }
    
    func loadMoreMovies() {
        // Increment Movie DB API page number
        page += 1
        
        // Fetch more movie data
        if let endpoint = typeEndpoint {
            let urlString = "\(Constants.movieDbUrl)movie/\(endpoint)?api_key=\(Constants.apiKey)&page=\(page)"
            NetworkUtilities.sharedInstance.fetchDataWithUrl(url:urlString, successCallback: { (json) -> Void in
                self.isLoading = false
                self.loadingIndicator.stopAnimating()
                for dict in json {
                    self.movies?.append(dict)
                    self.filteredMovies = self.movies
                }
                self.moviesTableView.reloadData()
                
                }, errorCallback: { (error) -> Void in
                    print("Error: \(error?.description)")
            })
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let filteredMovies = self.filteredMovies {
            return filteredMovies.count
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:"movieCell") as! MovieCell
        
        if let movies = self.filteredMovies {
            let movie = movies[indexPath.row]
            
            if let title = movie.title {
                cell.titleLabel.text = title
            }
            
            if let overview = movie.overview {
                cell.overviewLabel.text = "Synopsis: \(overview)"
            }
            
            if let posterPath = movie.posterPath {
                let posterUrl = NSURL(string: Constants.baseUrl + Constants.normalSize + posterPath)
                let imageRequest = NSURLRequest(url: posterUrl as! URL)
                
                cell.posterImageView.setImageWith(imageRequest as URLRequest, placeholderImage: UIImage(named: "no_poster"), success: { (imageRequest, imageResponse, image) -> Void in
                        // imageResponse will be nil if the image is cached
                        if imageResponse != nil {
                            cell.posterImageView.alpha = 0.0
                            cell.posterImageView.image = image
                            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                                cell.posterImageView.alpha = 1.0
                            })
                        } else {
                            cell.posterImageView.image = image
                        }
                    },
                                                  
                    failure: { (imageRequest, imageResponse, error) -> Void in
                        print("Error: \(error.localizedDescription)")
                })
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Deselect row appearance after it has been selected
        self.moviesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (!isLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = self.moviesTableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - self.moviesTableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && self.moviesTableView.isDragging) {
                loadingIndicator.startAnimating()
                isLoading = true
                loadMoreMovies()
            }
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = self.moviesTableView.indexPath(for: cell)
        if let movies = self.filteredMovies {
            let movie = movies[indexPath!.row]
            let detailViewController = segue.destination as! MovieDetailsViewController
            detailViewController.movie = movie
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // If search is empty, show all movies
            self.filteredMovies = self.movies
            self.moviesTableView.reloadData()
        } else {
            // Otherwise, fetch movies based on search string
            let urlString = "\(Constants.movieDbUrl)search/movie?api_key=\(Constants.apiKey)&query=\(searchText)"
            NetworkUtilities.sharedInstance.fetchDataWithUrl(url:urlString, successCallback: { (json) -> Void in
                self.filteredMovies = json
                self.moviesTableView.reloadData()
                }, errorCallback: { (error) -> Void in
                    print("Error: \(error?.description)")
            })
        }
    }
}
