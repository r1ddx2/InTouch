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
    func distance(to coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        let distanceInMeters = location1.distance(from: location2)
        
        let distanceInKilometers = (distanceInMeters / 1000.0).rounded(toPlaces: 1)
        
        return distanceInKilometers
    }
}

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension GeoPoint {
    func toCLLocationCoordinate2D() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
