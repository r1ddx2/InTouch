//
//  LocationResultViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/1.
//

import UIKit
import GooglePlaces
import GoogleMaps


class SearchResultsViewController: UITableViewController, UISearchResultsUpdating {
    
    private let googlePlaceManager = GooglePlacesManager.shared
    var searchResults: [Place] = []
    var selectLocationHandler: ((Place) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "LocationCell")
        tableView.tableFooterView = UIView()
    }

    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell", for: indexPath)
        let location = searchResults[indexPath.row]
        cell.textLabel?.text = location.name
        return cell
    }

    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selectedLocation = searchResults[indexPath.row]
        
        googlePlaceManager.resolveLocation(
            for: selectedLocation) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let coordinate):
                    selectedLocation.coordinate = coordinate
                    self.selectLocationHandler?(selectedLocation)
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        
        
        
    }

    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text, !query.isEmpty else {
            searchResults = []
            tableView.reloadData()
            return
        }

    }
    
    func update(with places: [Place]) {
        self.searchResults = places
        tableView.reloadData()
    }
}
