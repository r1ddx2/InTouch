//
//  CLLocationCoordinate2D + Extension.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/2.
//
import CoreLocation
import FirebaseFirestore

extension CLLocationCoordinate2D {
    func toGeoPoint() -> GeoPoint {
        return GeoPoint(latitude: self.latitude, longitude: self.longitude)
    }
}
