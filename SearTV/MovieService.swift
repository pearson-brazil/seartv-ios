//
//  MovieService.swift
//  SearTV
//
//  Created by Pearson on 11/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import Foundation

class MovieService {
  
  class func getPopularMovies(page: Int? = 1, completion: @escaping (Result<[Movie.ResponseModel.Result]>) -> Void) {
    
    getMovies(page: page ?? 1, path: "movie/popular", completion: completion)
  }
  
  class func getTopRatedMovies(page: Int? = 1, completion: @escaping (Result<[Movie.ResponseModel.Result]>) -> Void) {
    
    getMovies(page: page ?? 1, path: "movie/top_rated", completion: completion)
  }
  
  class func getUpcomingMovies(page: Int? = 1, completion: @escaping (Result<[Movie.ResponseModel.Result]>) -> Void) {
    
    getMovies(page: page ?? 1, path: "movie/upcoming", completion: completion)
  }
  
  class func getMovies(page: Int? = 1, path: String, completion: @escaping (Result<[Movie.ResponseModel.Result]>) -> Void) {
    
    var query = ""
    
    if let page = page, page > 1 {
      query = "page=\(page)"
    }
    
    Rest.get(path: path, query: query) { jsonResult in
      
      do {
        switch jsonResult {
        case .success(let json):
          
          guard let movieList = json["results"] as? [JSONObject] else {
            throw ReturnError.userMessage("Não foi possível obter os Filmes Populares. Por favor tente novamente mais tarde")
          }
          
          let movies = movieList.map {
            Movie.ResponseModel.Result(with: $0)
          }
          
          completion(Result.success(result: movies))
        case .failure(let error):
          throw error
        }
      } catch {
        completion(Result.failure(error: error as! ReturnError))
      }
    }
  }
}
