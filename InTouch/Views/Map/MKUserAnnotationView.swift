//
//  MKUserAnnotationView.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/6.
//

import MapKit
import UIKit

class MKUserAnnotationView: MKMarkerAnnotationView {
    static let identifier = "\(MKUserAnnotationView.self)"

    // MARK: - View load

    override var annotation: MKAnnotation? {
        willSet {
            guard let marker = newValue as? ITAnnotation else { return }

            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)

            tintColor = marker.markerTintColor

            let mapsButton = UIButton(frame: CGRect(
                origin: CGPoint.zero,
                size: CGSize(width: 45, height: 45)
            ))
            mapsButton.setBackgroundImage(marker.icon, for: .normal)
            rightCalloutAccessoryView = mapsButton
        }
    }
}

class ITAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var markerTintColor: UIColor?
    var imageBlock: ImageBlock?
    var place: String?
    var icon: UIImage?

    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, imageBlock: ImageBlock?, icon: UIImage?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageBlock = imageBlock
        markerTintColor = .blue
        self.icon = icon
    }
}
