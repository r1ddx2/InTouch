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
        GeoPoint(latitude: latitude, longitude: longitude)
    }

    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: latitude, longitude: longitude)
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        let distanceInMeters = location1.distance(from: location2)

        let distanceInKilometers = (distanceInMeters / 1000.0).rounded(toPlaces: 1)

        return distanceInKilometers
    }
}
