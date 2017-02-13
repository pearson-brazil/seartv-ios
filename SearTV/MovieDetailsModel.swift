//
//  MovieDetailsModel.swift
//  SearTV
//
//  Created by Pearson on 12/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import Foundation


struct MovieDetails {
  
  struct ResponseModel {
    typealias GenreModel = Genre.ResponseModel
    
    let backdrop_path: String?
    let budget: Int?
    let genres: [GenreModel]?
    let id: Int
    let original_title: String?
    let overview: String?
    let vote_average: Double?
    let revenue: Int?
    let title: String?
    let release_date: Date?
    let runtime: Int?

    
    init(with json: JSONObject?) {
      backdrop_path = json?["backdrop_path"] as? String
      budget = json?["budget"] as? Int
      id = (json?["id"] as! Int) 
      original_title = json?["original_title"] as? String
      overview = json?["overview"] as? String
      vote_average = json?["vote_average"] as? Double
      revenue = json?["revenue"] as? Int
      title = json?["title"] as? String
      
      runtime = json?["runtime"] as? Int
      
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      let dateString = json?["release_date"] as? String
      
      release_date = formatter.date(from: dateString ?? "")
      
      genres = (json?["genres"] as? [JSONObject])?.map {
        GenreModel(with: $0)
      }
    }
  }
  
  struct ViewModel {
    let title: String
    let originalTitle: String
    let backDropPath: String
    let voteAverage: Int
    let overview: String
    let revenue: String
    let budget: String
    let releaseDate: String
    let genre: String
    let runtime: String
    
    
    init(with responseModel: ResponseModel) {
      title = responseModel.title ?? ""
      originalTitle = responseModel.original_title ?? ""
      backDropPath = responseModel.backdrop_path ?? ""
      voteAverage = Int((responseModel.vote_average ?? 0.0)/2)
      overview = responseModel.overview ?? ""
      
      let formatter = NumberFormatter()
      formatter.locale = Locale.current
      formatter.numberStyle = .currency
      
      if let formattedTipAmount = formatter.string(from: responseModel.revenue as NSNumber? ?? 0 as NSNumber) {
        revenue = formattedTipAmount
      } else {
        revenue = ""
      }
      
      if let formattedTipAmount = formatter.string(from: responseModel.budget as NSNumber? ?? 0 as NSNumber) {
        budget = formattedTipAmount
      } else {
        budget = ""
      }
      
      if let date = responseModel.release_date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        releaseDate = formatter.string(from: date)
      } else {
        releaseDate = ""
      }
      
      genre = responseModel.genres?.first?.name ?? ""
      runtime = "\((responseModel.runtime ?? 0)) min"
    }
  }
  
}
