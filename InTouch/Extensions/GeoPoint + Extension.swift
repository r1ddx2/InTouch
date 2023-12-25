//
//  GeoPoint + Extension.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/22.
//

import CoreLocation
import FirebaseFirestore
import Foundation

extension GeoPoint {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
