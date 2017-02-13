//
//  MovieDetailsInteractor.swift
//  SearTV
//
//  Created by Pearson on 12/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import Foundation

class MovieDetailsInteractor {
  static var shared = MovieDetailsInteractor()
  private init() {}
  
  var selectedMovie: Movie.ResponseModel.Result?
  
  func getMovie(completion: @escaping (Content<MovieDetails.ViewModel>) -> Void) {
    guard let selected = selectedMovie else {
      completion(Content.error(ReturnError.userMessage("Não foi possível obter os detalhes do filme. Por favor tente novamente mais tarde")))
      return
    }
      
    MovieService.getMovie(withId: selected.id) { result in
      switch result {
      case .success(let data):
        
        let viewModel = MovieDetails.ViewModel(with: data)
        
        completion(Content.success(viewModel))
      case .failure(let error):
        completion(Content.error(error))
      }
    }

  }

}
