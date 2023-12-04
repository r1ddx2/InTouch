//
//  GooglePlacesManager.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/1.
//

import Foundation
import UIKit
import GooglePlaces

enum GooglePlacesError: Error {
    case noResult
    case failToGetCoordinates
}

class GooglePlacesManager: NSObject {
    
    static let shared = GooglePlacesManager()
    private let client = GMSPlacesClient.shared()
    
    func findPlaces(
        query: String,
        completion: @escaping (Result<[Place], Error>) -> Void
    ) {
        let filter = GMSAutocompleteFilter()
        filter.type = .geocode
        client.findAutocompletePredictions(
            fromQuery: query,
            filter: filter,
            sessionToken: nil
        ) { (results, error) in
            
            guard let results = results,
                  error == nil else {
                completion(.failure(GooglePlacesError.noResult))
                return
            }
            
            let places: [Place] = results.compactMap({
                Place(
                    name: $0.attributedFullText.string,
                    identifier: $0.placeID,
                    address: $0.attributedPrimaryText.string
                )
            })
            
            completion(.success(places))
        }
            
    }
    
    func resolveLocation(
        for place: Place,
        completion: @escaping (Result<CLLocationCoordinate2D, Error>) -> Void
    ) {
        client.fetchPlace(
            fromPlaceID: place.identifier,
            placeFields: .coordinate,
            sessionToken: nil) { googlePlace, error in
                
                guard let googlePlace = googlePlace, error == nil else {
                    completion(.failure(GooglePlacesError.failToGetCoordinates))
                    return
                }
        
                let coordinate = CLLocationCoordinate2D(
                    latitude: googlePlace.coordinate.latitude,
                    longitude: googlePlace.coordinate.longitude
                )
                completion(.success(coordinate))
            }
    }
}
