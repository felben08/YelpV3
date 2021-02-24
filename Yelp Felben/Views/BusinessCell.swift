//
//  BusinessCell.swift
//  Yelp
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    
    @IBOutlet fileprivate var distanceLabel: UILabel!
    @IBOutlet fileprivate var nameLabel: UILabel!
    @IBOutlet fileprivate var listingImageView: UIImageView!
    @IBOutlet fileprivate var ratingImageView: UIImageView!
    @IBOutlet fileprivate var ratingLabel: UILabel!
    @IBOutlet fileprivate var reviewsLabel: UILabel!
    
    @IBOutlet fileprivate var addressLabel: UILabel!
    @IBOutlet fileprivate var categoriesLabel: UILabel!
    
    var business: Business! {
        didSet {
            self.distanceLabel.text = business.distance
            self.nameLabel.text = business.name
            self.reviewsLabel.text = "\(business.reviewCount ?? 0) reviews"
            self.addressLabel.text = business.displayAddress
            self.categoriesLabel.text = business.categories
            
            if let businessImageURL = business.imageURL {
                self.listingImageView.setImageWith(businessImageURL, placeholderImage: #imageLiteral(resourceName: "yelpIcon"))
            } else {
                self.listingImageView.image = #imageLiteral(resourceName: "yelpIcon")
            }
            if let ratingImageURL = business.ratingImageURL {
                // FIXME: - Placeholder for rating...?
                self.ratingImageView.setImageWith(ratingImageURL)
            }
            
            if let rating = business.rating {
                self.ratingLabel.text = "Ratings: " + rating.stringValue
                self.ratingLabel.adjustsFontSizeToFitWidth = true
                self.ratingLabel.textAlignment = .center
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.listingImageView.layer.cornerRadius = 3.5
        self.listingImageView.clipsToBounds = true
    }

}
