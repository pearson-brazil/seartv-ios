//
//  MovieInteractor.swift
//  SearTV
//
//  Created by Pearson on 11/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import Foundation

class MoviesInteractor {
  static var shared = MoviesInteractor()
  private init() {}
  
  
  struct MovieList {
    var list: [Movie.ResponseModel.Result]
    var page: Int
  }
  
  var popularMovies = MovieList(list: [], page: 1)
  var topRatedMovies = MovieList(list: [], page: 1)
  var upcomingMovies = MovieList(list: [], page: 1)
  
  
  
  func getPopularMovies(completion: @escaping (Content<[Movie.ViewModel]>) -> Void) {
    MovieService.getPopularMovies(page: popularMovies.page) { result in
      switch result {
      case .success(let movies):
        
        self.popularMovies.list.append(contentsOf: movies)
        
        let viewModels = self.popularMovies.list.map {
          Movie.ViewModel(id: $0.id, posterPath: $0.poster_path ?? "")
        }
        
        self.popularMovies.page += 1
        
        completion(Content.success(viewModels))
      case .failure(let error):
        completion(Content.error(error))
      }
    }
  }
  
  func getTopRatedMovies(completion: @escaping (Content<[Movie.ViewModel]>) -> Void) {
    MovieService.getTopRatedMovies(page: topRatedMovies.page) { result in
      switch result {
      case .success(let movies):
        
        self.topRatedMovies.list.append(contentsOf: movies)
        
        let viewModels = self.topRatedMovies.list.map {
          Movie.ViewModel(id: $0.id, posterPath: $0.poster_path ?? "")
        }
        
        self.topRatedMovies.page += 1
        
        completion(Content.success(viewModels))
      case .failure(let error):
        completion(Content.error(error))
      }
    }
  }
  
  func getUpcomingMovies(completion: @escaping (Content<[Movie.ViewModel]>) -> Void) {
    MovieService.getUpcomingMovies(page: upcomingMovies.page) { result in
      switch result {
      case .success(let movies):
        
        self.upcomingMovies.list.append(contentsOf: movies)
        
        let viewModels = self.upcomingMovies.list.map {
          Movie.ViewModel(id: $0.id, posterPath: $0.poster_path ?? "")
        }
        
        self.upcomingMovies.page += 1
        
        completion(Content.success(viewModels))
      case .failure(let error):
        completion(Content.error(error))
      }
    }
  }
  
  func setSelectedMovie(with viewModel: Movie.ViewModel) {
    var allMovies = popularMovies.list
    allMovies.append(contentsOf: topRatedMovies.list)
    allMovies.append(contentsOf: upcomingMovies.list)
    
    let selected = allMovies.first {
      $0.id == viewModel.id
    }
    
    MovieDetailsInteractor.shared.selectedMovie = selected
  }
}
