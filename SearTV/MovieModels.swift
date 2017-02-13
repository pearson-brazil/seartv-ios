//
//  MovieModels.swift
//  SearTV
//
//  Created by Pearson on 11/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import Foundation

struct Movie {
  struct ResponseModel {
    let page: Int?
    let results: [Result]?
    let total_results: Int?
    let total_pages: Int?
    
    struct Result {
      let poster_path: String?
      let adult: Bool?
      let overview: String?
      let release_date: String?
      let genre_ids: [Int]?
      let id: Int
      let original_title: String?
      let original_language: String?
      let title: String?
      let backdrop_path: String?
      let popularity: Double?
      let vote_count: Int?
      let video: Bool?
      let vote_average: Double?
      
      init(with json: JSONObject?) {
        poster_path = json?["poster_path"] as? String
        adult = json?["adult"] as? Bool
        overview = json?["overview"] as? String
        release_date = json?["release_date"] as? String
        genre_ids = json?["genre_ids"] as? [Int]
        id = (json?["id"] as? Int) ?? -1
        original_title = json?["original_title"] as? String
        original_language = json?["original_language"] as? String
        title = json?["title"] as? String
        backdrop_path = json?["backdrop_path"] as? String
        popularity = json?["popularity"] as? Double
        vote_count = json?["vote_count"] as? Int
        video = json?["video"] as? Bool
        vote_average = json?["vote_average"] as? Double
      }
    }
    
    init(with json: JSONObject?) {
      page = json?["page"] as? Int
      total_results = json?["total_results"] as? Int
      total_pages = json?["total_pages"] as? Int
      
      results = (json?["results"] as? [JSONObject])?.map {
        Result(with: $0)
      }
    }
    
  }
  
  struct ViewModel {
    let id: Int
    let posterPath: String
  }
}
