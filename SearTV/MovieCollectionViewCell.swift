//
//  MovieCollectionViewCell.swift
//  SearTV
//
//  Created by Pearson on 11/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var imageView: UIImageView!
  
  func update(with data: Movie.ViewModel) {
    let url = "https://image.tmdb.org/t/p/w150/" + data.posterPath
    
    imageView.kf.indicatorType = .activity

    imageView.kf.setImage(with: URL(string: url))
  }
}

class LoadingCollectionViewCell: UICollectionViewCell {
  @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
}
