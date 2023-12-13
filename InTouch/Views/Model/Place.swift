//
//  Place.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/2.
//

import Foundation
import GoogleMaps
import GooglePlaces

struct Place {
    let name: String
    let identifier: String
    let address: String
    var coordinate: CLLocationCoordinate2D?
}
