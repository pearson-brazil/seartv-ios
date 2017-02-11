//
//  GenreService.swift
//  SearTV
//
//  Created by Pearson on 11/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import Foundation

class GenreService {
  
  class func getGenres(completion: @escaping (Result<[Genre.ResponseModel]>) -> Void) {
    
    Rest.get(path: "genre/movie/list") { jsonResult in
      
      do {
        switch jsonResult {
        case .success(let json):
          
          guard let genreList = json["genres"] as? [JSONObject] else {
            throw ReturnError.userMessage("Não foi possível obter os Gêneros. Por favor tente novamente mais tarde")
          }
          
          let genres: [Genre.ResponseModel] = genreList.map {
            Genre.ResponseModel(with: $0)
          }
          
          completion(Result.success(result: genres))
        case .failure(let error):
          throw error
        }
      } catch {
        completion(Result.failure(error: error as! ReturnError))
      }
    }
  }
}
