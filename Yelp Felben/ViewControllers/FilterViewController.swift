//
//  FilterViewController.swift
//  Yelp
//
//  Created by Felben Abecia on 2/16/21.
//  Copyright © 2021 Felben Abecia. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet fileprivate var tableView: UITableView!
    
    
    // MARK: Stored Properties
    var filters = [Filter : [Any]]()
    var searchTerm: SearchTerm?
    
    // MARK: Property Observers
    
    fileprivate var offeringDeal = false {
        didSet {
            searchTerm?.deals = offeringDeal
        }
    }
    
    fileprivate var categoryFilters = [String : Bool]() {
        didSet {
            guard searchTerm != nil else { return }
            let categoriesToAdd = categoryFilters.filter {$0.value != false}.map {$0.key}
            searchTerm!.categories = categoriesToAdd.count > 0 ? categoriesToAdd : nil
        }
    }
    
    fileprivate var sortMode = YelpSortMode.bestMatched {
        didSet {
            searchTerm?.sort = sortMode
        }
    }
    
    fileprivate var distanceLimit = 5 {
        didSet {
            searchTerm?.distanceLimit = Double(distanceLimit)
        }
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var catFilters = [String : Bool]()
        guard searchTerm != nil else { return }
        if let categories = searchTerm!.categories {
            for category in categories {
                catFilters[category] = true
            }
        }
        categoryFilters = catFilters
        for (yelpCategory, _)  in YelpCategories {
            if categoryFilters[yelpCategory] == nil {
                categoryFilters[yelpCategory] = false
            }
        }
        sortMode = searchTerm?.sort ?? .bestMatched
        offeringDeal = searchTerm?.deals ?? false
        distanceLimit = Int(searchTerm?.distanceLimit ?? 5)
        
        setupFilters()
        
    }
    
    // MARK: Helpers
    
    func setupFilters() {
        filters[.offeringDeal] = [true]
        filters[.distance] = (5...YelpMaxRadiusFilter).filter { $0 % 5 == 0 }
        filters[.sortBy] = [YelpSortMode.bestMatched, YelpSortMode.distance, YelpSortMode.highestRated]
        filters[.category] = YelpCategories.map {$0.key}.sorted {$0 < $1}
    }
    
    // MARK: Target-Action
    
    @IBAction fileprivate func onCancel(sender: AnyObject?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction fileprivate func onSave(sender: AnyObject?) {
        performSegue(withIdentifier: "filtersVC", sender: self)
    }
}


// MARK: - UITableView

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let filter = Filter(rawValue: indexPath.section)!
        if indexPath.section == 1 {
            let distances = filters[filter] as! [Int]
            distanceLimit = distances[indexPath.row]
            self.tableView.reloadData()
        }
        
        if indexPath.section == 2 {
            let sortModes = filters[filter] as! [YelpSortMode]
            sortMode = sortModes[indexPath.row]
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filter = Filter(rawValue: section)!
        return filter == .offeringDeal ? nil : filter.description
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filter = Filter(rawValue: section)!
        return filters[filter]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let filter = Filter(rawValue: indexPath.section)!
        let cell = cellForFilter(filter: filter, withIndexPath: indexPath)
        return cell
    }
    
    fileprivate func cellForFilter(filter: Filter, withIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let switchCell = tableView.dequeueReusableCell(withIdentifier: "switchCell") as! SwitchCell
        let selectionCell = tableView.dequeueReusableCell(withIdentifier: "selectionCell") as! SelectionCell
        
        switch filter {
        case .offeringDeal:
            switchCell.filterNameLabel.text = filter.description
            switchCell.filterSwitch.isOn = self.offeringDeal
            switchCell.switchAction = {
                isOn in
                self.offeringDeal = isOn
            }
            return switchCell
        case .distance:
            let distances = filters[filter] as! [Int]
            selectionCell.filterNameLabel.text = "\(distances[indexPath.row]) miles"
            selectionCell.checkMark = distances[indexPath.row] == distanceLimit
            return selectionCell
        case .sortBy:
            let sortModes = filters[filter] as! [YelpSortMode]
            selectionCell.filterNameLabel.text = sortModes[indexPath.row].description
            selectionCell.checkMark = sortModes[indexPath.row] == sortMode
            return selectionCell
        case .category:
            let categories = filters[filter] as! [String]
            switchCell.filterNameLabel.text = YelpCategories[categories[indexPath.row]] ?? ""
            switchCell.filterSwitch.isOn = categoryFilters[categories[indexPath.row]] ?? false
            switchCell.switchAction = {
                isOn in
                self.categoryFilters[categories[indexPath.row]] = isOn
            }
            return switchCell
        }
    }
    
}
