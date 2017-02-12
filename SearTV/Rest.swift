//
//  Rest.swift
//  SCB-FastEasy
//
//  Created by André Pinto on 18/10/16.
//  Copyright © 2016 SCB. All rights reserved.
//

import Foundation

typealias JSONObject = [String:Any]
typealias JSONResult = Result<JSONObject>

enum ValidationError: Error {
    case missing(String)
    case invalid(String, Any)
}

enum ReturnError: Error {
    case apiError(code: Int, message:String)
    case invalidJSON
    case userMessage(String)
}

enum Result<T> {
    case success(result: T)
    case failure(error: ReturnError)
}

enum Content<T> {
  case success(T)
  case error(ReturnError)
  case loading
}

protocol JSONValidation {
  static func validJson(from data: Data?) throws -> JSONObject
}

class Rest {
  static var baseURL = "https://api.themoviedb.org/3/%@?api_key=0d2d0307fd89b460e176ba0033dc5c46&language=pt-BR%@"
  static var defaultHeader: [String:String]? = ["Content-Type": "application/json"]
  
  static private let session = URLSession.shared

  enum HTTPMethod: String {
    case put = "PUT"
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
  }

  internal class func connect(method: String,
                             path: String,
                             query: String? = "",
                             timeout: TimeInterval? = 30,
                             redirects: Bool? = true,
                             headers: [String:String]? = defaultHeader,
                             jsonObject: JSONObject? = nil,
                             completion: @escaping (JSONResult) -> Void) throws {
    // Setup URL
    
    var queryString = query ?? ""
    if !queryString.isEmpty {
      queryString = "&\(queryString)"
    }
    
    let appendedUrl = String(format: baseURL, path, queryString)
    guard let components = URLComponents(string: appendedUrl) else {
      throw ValidationError.invalid("baseURL", baseURL)
    }

    guard let url = components.url else {
      throw ValidationError.invalid("path", components.path)
    }

    // Setup Request
    var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
    request.httpMethod = method
    request.allHTTPHeaderFields = headers
    if let aTimeout = timeout { request.timeoutInterval = aTimeout }

    // Setup JSON
    if let validJson = jsonObject {
      let jsonData = try JSONSerialization.data(withJSONObject: validJson,
                                                options: .init(rawValue: 0))
      request.setValue("application/json", forHTTPHeaderField: "content-type")
      request.httpBody = jsonData
    }

    // Make the call
    session.dataTask(with: request, completionHandler: { data, response, error in

      OperationQueue.main.addOperation {

        do {
          // Check response errors
          if let responseError = error { throw responseError }

          let jsonObject = try validJson(from: data)

          // Successful result
          completion(JSONResult.success(result: jsonObject))

        } catch let theError {
          
          let error = ReturnError.apiError(code: (theError as NSError).code, message: (theError as NSError).domain)
          completion(JSONResult.failure(error: error))
        }
      }

    }).resume()

  }

  // MARK: - Public methods


  class func get(path: String, query: String? = "", headers: [String:String]? = defaultHeader, completion:@escaping (JSONResult) -> Void) {
    do {
      var allHeaders = defaultHeader
      for (key, value) in headers! {
        allHeaders?[key] = value
      }
      
      try connect(method: HTTPMethod.get.rawValue, path: path, query: query, redirects: false, headers: allHeaders,
                  completion: completion)
    } catch {
      completion(error as! JSONResult)
    }
  }

}

extension Rest : JSONValidation {
  static func validJson(from data: Data?) throws -> JSONObject {
    guard let responseData = data
      else { throw ReturnError.invalidJSON }
    
    // Convert JSON data to Swift JSON Object
    let responseJson = try JSONSerialization.jsonObject(with: responseData, options: [])
    
    // Assert there's a json object with status code

    guard let jsonObject = responseJson as? JSONObject
      else {
        throw ReturnError.invalidJSON
    }
    
    return jsonObject
  }
}
