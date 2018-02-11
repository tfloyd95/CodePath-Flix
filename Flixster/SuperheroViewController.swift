//
//  SuperheroViewController.swift
//  Flixster
//
//  Created by Tavien on 2/11/18.
//  Copyright © 2018 Warpedflo. All rights reserved.
//

import UIKit

enum SuperheroKeys
{
    static let posterPath = "poster_path"
}

class SuperheroViewController: UIViewController, UICollectionViewDataSource
{
    
    @IBOutlet weak var collectionView: UICollectionView!
    var movies: [[String: Any]] = []
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        collectionView.dataSource = self
        fetchMovies()
        
    }
    
    func fetchMovies()
    {
        //activityIndicator.startAnimating()
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data
            {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let movies = dataDictionary["results"] as! [[String: Any]]
                
                self.movies = movies
                self.collectionView.reloadData()
                //  self.activityIndicator.stopAnimating()
                //  self.refreshControl.endRefreshing()
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        
        
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PosterCell", for: indexPath) as! PosterCell
        
        let movie = movies[indexPath.item]
        if let posterPathString = movie["poster_path"] as? String
        {
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let posterURL = URL(string: baseUrl + posterPathString)!
            cell.posterImageView.af_setImage(withURL: posterURL)
            
        }
        return cell
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
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
