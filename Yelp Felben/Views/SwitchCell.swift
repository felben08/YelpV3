//
//  SwitchCell.swift
//  Yelp
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//
import UIKit

class SwitchCell: UITableViewCell {

    @IBOutlet var filterNameLabel: UILabel!
    @IBOutlet var filterSwitch: UISwitch!
    
    var switchAction: (Bool) -> Void = { (isOn: Bool) in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        filterSwitch.onTintColor = UIColor(red: 0.7725, green: 0.1059, blue: 0.0275, alpha: 1.0)
    }
    
    @IBAction func onSwitchChanged(_ sender: UISwitch) {
        switchAction(sender.isOn)
    }
}
