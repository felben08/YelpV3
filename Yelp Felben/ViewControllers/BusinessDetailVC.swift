//
//  BusinessDetailVC.swift
//  Yelp
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//

import UIKit
import MapKit

class BusinessDetailVC: UITableViewController {
    
    // MARK: Outlets
    
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var ratingImageView: UIImageView!
    @IBOutlet fileprivate var ratingLabel: UILabel!
    @IBOutlet fileprivate var categoriesLabel: UILabel!
    @IBOutlet fileprivate var numReviewsLabel: UILabel!
    @IBOutlet fileprivate var isClosedLabel: UILabel!
    @IBOutlet fileprivate var businessImageView: UIImageView!
    @IBOutlet fileprivate var mapView: MKMapView!
    @IBOutlet fileprivate var displayAddressLabel: UILabel!
    @IBOutlet fileprivate var displayPhoneLabel: UILabel!
    
    // MARK: Stored Properties
    
    var business: Business!
    
    // MARK: Lifecyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = business.name
        setupViews()
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 50
        
    }
    
    // MARK: Helpers
    
    fileprivate func setupViews() {
        setupLabels()
        setupImageViews()
        setupAnnotation()
    }
    
    fileprivate func setupLabels() {
        self.nameLabel.text = business.name
        self.numReviewsLabel.text = "\(business.reviewCount ?? 0) Reviews"
        self.categoriesLabel.text = business.categories
        
        if let isClosed = business.isClosed, isClosed {
            isClosedLabel.text = "Closed"
            isClosedLabel.textColor = .red
        } else {
            isClosedLabel.text = "Open"
            isClosedLabel.textColor = .green
        }
        print("business.address: \(business.displayAddress)")
        displayAddressLabel.text = business.displayAddress
        displayPhoneLabel.text = business.displayPhone
        
        if let rating = business.rating {
            self.ratingLabel.text = "Ratings: " + rating.stringValue
            self.ratingLabel.adjustsFontSizeToFitWidth = true
            self.ratingLabel.textAlignment = .center
        }
    }
    
    fileprivate func setupImageViews() {
        if let ratingImageURL = business.ratingImageURL {
            self.ratingImageView.setImageWith(ratingImageURL)
        }
        
        if let imageURL = business.imageURL {
            businessImageView.setImageWith(imageURL)
        }
    }
    
    fileprivate func setupAnnotation() {
        if let coordinate = business.coordinate, let latitude = coordinate.latitude, let longitude = coordinate.longitude {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            mapView.addAnnotation(annotation)
            mapView.showAnnotations([annotation], animated: true)
        }
    }
}
