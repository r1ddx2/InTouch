//
//  AddLocationViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/28.
//

import GoogleMaps
import GooglePlaces
import UIKit

class AddLocationViewController: ITBaseViewController, UISearchResultsUpdating {
    let googlePlacesManager = GooglePlacesManager.shared
    let searchVC = UISearchController(searchResultsController: SearchResultsViewController())
    var didSelectLocation: ((Place) -> Void)?

    // MARK: - View Load

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        configureSearchController()
    }

    // MARK: - Methods

    func configureSearchController() {
        searchVC.searchResultsUpdater = self
        searchVC.obscuresBackgroundDuringPresentation = false
        searchVC.searchBar.placeholder = "Search for a location"
        navigationItem.searchController = searchVC
        definesPresentationContext = true
    }

    func updateSearchResults(for _: UISearchController) {
        guard let query = searchVC.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            return
        }

        if let resultVC = searchVC.searchResultsController as? SearchResultsViewController {
            googlePlacesManager.findPlaces(query: query) { result in
                switch result {
                case let .success(places):

                    DispatchQueue.main.async {
                        resultVC.update(with: places)
                    }

                    resultVC.selectLocationHandler = { [weak self] place in
                        self?.didSelectLocation?(place)
                        self?.navigationController?.popToRootViewController(animated: false)
                    }

                case let .failure(error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
}
