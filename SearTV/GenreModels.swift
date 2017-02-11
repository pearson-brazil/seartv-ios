//
//  Genre.swift
//  SearTV
//
//  Created by Pearson on 11/02/17.
//  Copyright © 2017 Pearson. All rights reserved.
//

import Foundation


struct Genre {
    struct ResponseModel {
        let name: String?
        let id: String?
    
        init(with json: JSONObject?) {
            name = json?["name"] as? String
            id = json?["id"] as? String
        }
    }
    
    struct ViewModel {
        let name: String
    }
}
