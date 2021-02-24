//
//  YelpClient.swift
//  Yelp
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//
import UIKit

import AFNetworking

import CDYelpFusionKit

let YelpMaxRadiusFilter = 20

enum YelpSortMode: Int, CustomStringConvertible {
    case bestMatched = 0, distance, highestRated
    var description: String {
        switch self {
        case .bestMatched:
            return "Best Matched"
        case .distance:
            return "Distance"
        case .highestRated:
            return "Highest Rated"
        }
    }
}

class YelpClient: NSObject {
    
    //MARK: Shared Instance
    static let sharedInstance = YelpClient()
    
    var apiClient: CDYelpAPIClient!

    func configure() {
        // Authorize using your apiKey
        self.apiClient = CDYelpAPIClient(apiKey: "peE_XZCcqpIlne-wqbgCkk9sB8MHsCCK-obywystd4PzknC2I3YeQTIvrEBTe6Y2pNxj4M9xJ11xyJuUbJWp1NKOZs1Y5L_tD_DlQ9zHiY7JZkzRhNLpwl9nuFMrYHYx")
    }
    
    func searchWithTerm(_ term: String, completion: @escaping ([Business]?, Error?) -> Void) {
        searchWithTerm(term, sort: nil, categories: nil, deals: nil, distanceLimit: nil, shouldLoadMore: false, completion: completion)
    }
    
    func searchWithTerm(_ term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, distanceLimit: Double?, shouldLoadMore: Bool, completion: @escaping ([Business]?, Error?) -> Void) {
        
        // Default the location to San Francisco
        
        // Set offset limit
        var offset = Pagination.newPage.offSet
        var limit = Pagination.newPage.limit
        
        if shouldLoadMore {
            offset = Pagination.nextPage.offSet
            limit = Pagination.nextPage.limit
        }
        
        // =================
        
        print("term: \(term)")
        apiClient.searchBusinesses(byTerm: term,
                                   location: "San Francisco",
                                   latitude: 37.77493,
                                   longitude: -122.419415,
                                   radius: self.distanceInMeters(with: distanceLimit),
                                   categories: self.filterCategories(withFilters: categories),
                                   locale: .english_unitedStates,
                                   limit: limit,
                                   offset: offset,
                                   sortBy: self.businessSort(bySort: sort),
                                   priceTiers: nil,
                                   openNow: true,
                                   openAt: nil,
                                   attributes: self.getAttributeFilters(byDeals: deals)) { (response) in
            
            if let response = response,
                let businesses = response.businesses,
                businesses.count > 0 {
                
                var responseBusinesses = [Business]()
                
                for business in businesses {
                    let dictionary = NSMutableDictionary()
                    dictionary["name"] = business.name
                    dictionary["image_url"] = business.imageUrl?.absoluteString
                    dictionary["distance"] = business.distance
                    
                    if let reviewCount = business.reviewCount {
                        dictionary["review_count"] = NSNumber(value: reviewCount)
                    }
                    
                    dictionary["display_phone"] = business.displayPhone
                    dictionary["displayAddress"] = business.location?.displayAddress?.joined(separator: ", ")
                    
                    var categoriesArray = [String]()
                    if let categories = business.categories {
                        for category in categories {
                            if let title = category.title {
                                categoriesArray.append(title)
                            }
                        }
                    }
                    
                    dictionary["categories"]  = categoriesArray
                    
                    if let rating = business.rating {
                        dictionary["rating"]  = NSNumber.init(value: rating)
                    }
                    
                    if let isClosed = business.isClosed {
                        dictionary["is_closed"]  = isClosed
                    }
                    
                    let coordinateDictionary = NSMutableDictionary()
                    coordinateDictionary["latitude"] = business.coordinates?.latitude
                    coordinateDictionary["longitude"] = business.coordinates?.longitude
                    dictionary["coordinate"] = coordinateDictionary
                    
                    let bsns = Business(dictionary: dictionary)
                    
                    responseBusinesses.append(bsns)
                }
                
                completion(responseBusinesses, nil)
                
            } else {
                completion(nil, nil)
            }
        }
    }
    
    func getAttributeFilters(byDeals deals: Bool?) -> [CDYelpAttributeFilter]? {
    
        var attributes = [CDYelpAttributeFilter]()
        if deals == true {
            attributes.append(.deals)
        }
        
        print("attri: \(attributes)")
        return attributes
    }
    
    func distanceInMeters(with distanceLimit:Double?) -> Int {
        return Int(distanceLimit!*1610) // miles to meters
    }
    
    func businessSort(bySort sort:YelpSortMode?) -> CDYelpBusinessSortType? {
        
        switch sort {
        case .bestMatched:
            return .bestMatch
        case .distance:
            return .distance
        case .highestRated:
            return .rating
        default:
            return .bestMatch
        }
    }
    
    func filterCategories(withFilters categories:[String]?) -> [CDYelpCategoryAlias]? {
        
        var categoryAlias = [CDYelpCategoryAlias]()
        
        if let category_filters = categories, category_filters.count > 0 {
            
            if category_filters.contains("african") {
                categoryAlias.append(.african)
            }
            
            if category_filters.contains("chinese") {
                categoryAlias.append(.chinese)
            }
            
            if category_filters.contains("french") {
                categoryAlias.append(.french)
            }
            
            if category_filters.contains("japanese") {
                categoryAlias.append(.japanese)
            }
            
            if category_filters.contains("mexican") {
                categoryAlias.append(.mexican)
            }
            
            if category_filters.contains("russian") {
                categoryAlias.append(.russian)
            }
            
        }
        
        return categoryAlias
    }
    
        /*return self.get("search", parameters: parameters,
                        success: { (operation: AFHTTPRequestOperation, response: Any) -> Void in
                            if let response = response as? [String: Any]{
                                let dictionaries = response["businesses"] as? [NSDictionary]
                                if dictionaries != nil {
                                    completion(Business.businesses(array: dictionaries!), nil)
                                }
                            }
                        },
                        failure: { (operation: AFHTTPRequestOperation?, error: Error) -> Void in
                            print("YelpClient: \(error.localizedDescription)")
                            completion(nil, error)
                        })!
 */
}
