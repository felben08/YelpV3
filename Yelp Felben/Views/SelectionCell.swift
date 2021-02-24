//
//  SelectionCell.swift
//  Yelp
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//

import UIKit

class SelectionCell: UITableViewCell {

    @IBOutlet var filterNameLabel: UILabel!
    
    var checkMark = false {
        didSet {
            accessoryType = checkMark ? .checkmark : .none
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
