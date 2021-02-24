//
//  Business.swift
//  Yelp
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//

import UIKit

class Business: NSObject {
    let name: String?
    let displayAddress: String?
    let imageURL: URL?
    let categories: String?
    let distance: String?
    let ratingImageURL: URL?
    let rating: NSNumber?
    let reviewCount: NSNumber?
    let displayPhone: String?
    let isClosed: Bool?
    let hours: [String]?
    let coordinate: (latitude: Double?, longitude: Double?)?
    
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        
        let imageURLString = dictionary["image_url"] as? String
        if imageURLString != nil {
            imageURL = URL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        isClosed = dictionary["is_closed"] as? Bool
        
        displayPhone = dictionary["display_phone"] as? String
        
        displayAddress = dictionary["displayAddress"] as? String
        
        print("addresssaved: \(displayAddress)")
        let categoriesArray = dictionary["categories"] as? [String]
        if categoriesArray != nil {
            var categoryNames = [String]()
            for category in categoriesArray! {
                categoryNames.append(category)
            }
            categories = categoryNames.joined(separator: ", ")
        } else {
            categories = nil
        }
        
        let distanceMeters = dictionary["distance"] as? NSNumber
        
        //(dictionary["location"] as? NSDictionary)?["coordinate"] as? NSDictionary
        let coordinate = dictionary["coordinate"] as? NSDictionary
        let latitude = coordinate?["latitude"] as? Double
        let longitude = coordinate?["longitude"] as? Double
        self.coordinate = (latitude: latitude, longitude: longitude)
        
        if distanceMeters != nil {
            let milesPerMeter = 0.000621371
            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
        } else {
            distance = nil
        }
        
        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
        if ratingImageURLString != nil {
            ratingImageURL = URL(string: ratingImageURLString!)
        } else {
            ratingImageURL = nil
        }
        
        reviewCount = dictionary["review_count"] as? NSNumber
        
        rating = dictionary["rating"] as? NSNumber
        
        hours = dictionary["hours"] as? [String]
        
    }
    
    class func businesses(array: [NSDictionary]) -> [Business] {
        var businesses = [Business]()
        for dictionary in array {
            let business = Business(dictionary: dictionary)
            businesses.append(business)
        }
        return businesses
    }
    
    class func searchWithTerm(term: String, completion: @escaping ([Business]?, Error?) -> Void) {
        YelpClient.sharedInstance.searchWithTerm(term, completion: completion)
    }
    
    class func searchWithTerm(term: String, sort: YelpSortMode?, categories: [String]?, deals: Bool?, distanceLimit: Double?, shouldLoadMore: Bool = false, completion: @escaping ([Business]?, Error?) -> Void){
        YelpClient.sharedInstance.searchWithTerm(term, sort: sort, categories: categories, deals: deals, distanceLimit: distanceLimit, shouldLoadMore: shouldLoadMore, completion: completion)
    }
}
