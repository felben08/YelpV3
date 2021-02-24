//
//  Pagination.swift
//  Yelp
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//

// offset, limit

import Foundation

struct Pagination {
    static var limit = 10
    static var offSet = 0
    
    static var nextPage: (offSet: Int, limit: Int) {
        offSet += limit
        return (offSet: offSet, limit: limit)
    }
    
    static var newPage: (offSet: Int, limit: Int) {
        offSet = 0
        return (offSet: offSet, limit: limit)
    }
    
}
