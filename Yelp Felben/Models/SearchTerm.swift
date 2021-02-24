//
//  SearchTerm.swift
//  Yelp
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//

import Foundation

struct SearchTerm {
    var term: String
    var sort: YelpSortMode?
    var categories: [String]?
    var deals: Bool?
    var distanceLimit: Double?
    
    init(term: String = "", sort: YelpSortMode? = .bestMatched, categories: [String]? = nil, deals: Bool? = nil, distanceLimit: Double? = 5) {
        self.term = term
        self.sort = sort
        self.categories = categories
        self.deals = deals
        if let distance = distanceLimit {
            self.distanceLimit = distance
        } else {
            self.distanceLimit = nil
        }
    }
    
}
