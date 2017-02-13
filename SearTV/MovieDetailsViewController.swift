//
//  MovieDetailsViewController.swift
//  SearTV
//
//  Created by Pearson on 12/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
  
  var content: Content<MovieDetails.ViewModel> = .loading {
    didSet {
      updateViews()
    }
  }
  
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var loadingView: UIView!
  @IBOutlet weak var errorView: UIView!
  @IBOutlet weak var errorLabel: UILabel!
  
  @IBOutlet weak var backDropImageView: UIImageView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var yearLabel: UILabel!
  @IBOutlet weak var genreLabel: UILabel!
  @IBOutlet weak var runtimeLabel: UILabel!
  @IBOutlet weak var overviewLabel: UILabel!
  @IBOutlet weak var originalTitleLabel: UILabel!
  @IBOutlet weak var budgetLabel: UILabel!
  @IBOutlet weak var revenueLabel: UILabel!
  
  
  @IBOutlet weak var star1ImageView: UIImageView!
  @IBOutlet weak var star2ImageView: UIImageView!
  @IBOutlet weak var star3ImageView: UIImageView!
  @IBOutlet weak var star4ImageView: UIImageView!
  @IBOutlet weak var star5ImageView: UIImageView!
  
  override func viewWillAppear(_ animated: Bool) {
    updateViews()
    
    MovieDetailsInteractor.shared.getMovie { content in
      self.content = content
    }
  }
  
  func updateViews() {
    switch content {
    case .success(let data):
      errorView.isHidden = true
      loadingView.isHidden = true
      contentView.isHidden = false
      
      updateLabels(viewModel: data)
      updateStars(voteAverage: data.voteAverage)
      updateImage(path: data.backDropPath)
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
  }
  
  func updateLabels(viewModel: MovieDetails.ViewModel) {
    titleLabel.text = viewModel.title
    yearLabel.text = viewModel.releaseDate
    genreLabel.text = viewModel.genre
    runtimeLabel.text = viewModel.runtime
    overviewLabel.text = viewModel.overview
    originalTitleLabel.text = viewModel.originalTitle
    revenueLabel.text = viewModel.revenue
    budgetLabel.text = viewModel.budget
  }
  
  func updateImage(path: String) {
    let url = "https://image.tmdb.org/t/p/w500/" + path
    
    backDropImageView.kf.indicatorType = .activity
    
    backDropImageView.kf.setImage(with: URL(string: url))
  }
  
  func updateStars(voteAverage: Int) {
    
    star1ImageView.image = #imageLiteral(resourceName: "ic_star_off")
    star2ImageView.image = #imageLiteral(resourceName: "ic_star_off")
    star3ImageView.image = #imageLiteral(resourceName: "ic_star_off")
    star4ImageView.image = #imageLiteral(resourceName: "ic_star_off")
    star5ImageView.image = #imageLiteral(resourceName: "ic_star_off")
    
    switch voteAverage {
    case 1:
      star1ImageView.image = #imageLiteral(resourceName: "ic_star_on")
    case 2:
      star1ImageView.image = #imageLiteral(resourceName: "ic_star_on")
      star2ImageView.image = #imageLiteral(resourceName: "ic_star_on")
    case 3:
      star1ImageView.image = #imageLiteral(resourceName: "ic_star_on")
      star2ImageView.image = #imageLiteral(resourceName: "ic_star_on")
      star3ImageView.image = #imageLiteral(resourceName: "ic_star_on")
    case 4:
      star1ImageView.image = #imageLiteral(resourceName: "ic_star_on")
      star2ImageView.image = #imageLiteral(resourceName: "ic_star_on")
      star3ImageView.image = #imageLiteral(resourceName: "ic_star_on")
      star4ImageView.image = #imageLiteral(resourceName: "ic_star_on")
    case 5:
      star1ImageView.image = #imageLiteral(resourceName: "ic_star_on")
      star2ImageView.image = #imageLiteral(resourceName: "ic_star_on")
      star3ImageView.image = #imageLiteral(resourceName: "ic_star_on")
      star4ImageView.image = #imageLiteral(resourceName: "ic_star_on")
      star5ImageView.image = #imageLiteral(resourceName: "ic_star_on")
    default: break
    }
  }

  
}
