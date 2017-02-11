//
//  GenresManager.swift
//  SearTV
//
//  Created by Pearson on 11/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import Foundation

class GenresInteractor {
  static var shared = GenresInteractor()
  
  var list: [Genre.ResponseModel]?
  
  private init() {}
  
  func getGenres(completion: @escaping (Content<[Genre.ViewModel]>) -> Void) {
    
    if let genres = list {
      
      let viewModels = genres.map {
        Genre.ViewModel(name: $0.name ?? "")
      }
      
      completion(Content.success(viewModels))
      
    } else {
      
      GenreService.getGenres() { result in
        switch result {
        case .success(let genres):
          
          self.list = genres
          let viewModels = genres.map {
            Genre.ViewModel(name: $0.name ?? "")
          }
          
          completion(Content.success(viewModels))
        case .failure(let error):
          completion(Content.error(error))
        }
      }
    }
  }
  
  func getGenre(byIndex index: Int) -> Genre.ResponseModel? {
    
    if let list = list,
      index < list.count,
      index >= 0 {
      return list[index]
    }
    
    return nil
  }
}
