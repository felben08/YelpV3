//
//  YelpAnnotation.swift
//  Yelp
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//

import MapKit

class YelpAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var atIndex: Int?
    
    init(coordinate: CLLocationCoordinate2D, at index: Int) {
        self.coordinate = coordinate
        self.atIndex = index
        title = nil
        subtitle = nil
    }
}
