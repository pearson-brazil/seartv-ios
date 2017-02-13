//
//  MoviesViewController.swift
//  SearTV
//
//  Created by Pearson on 11/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import UIKit
import Kingfisher

class MoviesViewController: UIViewController {
  
  enum Filter: Int {
    case popular = 0
    case topRated = 1
    case upcoming = 2
  }
  
  var currentFilter: Filter = .popular {
    didSet {
      getMovies()
    }
  }

  var content: Content<[Movie.ViewModel]> = .loading {
    didSet {
      updateViews()
    }
  }

  @IBOutlet weak var collectionView: UICollectionView!
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var errorView: UIView!
  @IBOutlet weak var errorLabel: UILabel!
  
  override func viewWillAppear(_ animated: Bool) {
    updateViews()
    getMovies()
  }
  
  func getMovies() {
    
    content = .loading
    
    let completionHandler: (Content<[Movie.ViewModel]>) -> Void = { content in
      self.content = content
    }
    
    switch currentFilter {
    case .topRated:
      MoviesInteractor.shared.getTopRatedMovies(completion: completionHandler)
    case .popular:
      MoviesInteractor.shared.getPopularMovies(completion: completionHandler)
    case .upcoming:
      MoviesInteractor.shared.getUpcomingMovies(completion: completionHandler)
    }
  }
  
  func updateViews() {
    switch content {
    case .success:
      errorView.isHidden = true
      loadingView.isHidden = true
      contentView.isHidden = false
      
      collectionView.reloadData()
    case .loading:
      errorView.isHidden = true
      loadingView.isHidden = false
      contentView.isHidden = true
    case .error(let error):
      errorView.isHidden = false
      loadingView.isHidden = true
      contentView.isHidden = true
      
      if case .userMessage(let message) = error {
        errorLabel.text = message
      }
    }
    
    view.layoutIfNeeded()
  }

  @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
    currentFilter = Filter(rawValue: sender.selectedSegmentIndex) ?? .popular
  }
}

extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if case .success(let movies) = content {
      MoviesInteractor.shared.setSelectedMovie(with: movies[indexPath.row])
      performSegue(withIdentifier: "ShowMovieDetails", sender: nil)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
    
    let index = indexPath.row
    
    if case .success(let movies) = content {
      
      if index == movies.count {
        let loadingcell = collectionView.dequeueReusableCell(withReuseIdentifier: "LoadingCollectionViewCell", for: indexPath) as! LoadingCollectionViewCell
        loadingcell.activityIndicatorView.startAnimating()
        
        return loadingcell
      } else {
        cell.update(with: movies[indexPath.row])
      }
      
    }
    
    return cell
  }
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if case .success(let movies) = content {
      return movies.count + 1
    }
    
    return 0
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrollViewHeight = scrollView.frame.size.height
    let scrollContentSizeHeight = scrollView.contentSize.height
    let scrollOffset = scrollView.contentOffset.y
    
    if (scrollOffset + scrollViewHeight) == scrollContentSizeHeight {
      // estamos no final da scrollView
      getMovies()
    }
  }
  
}
