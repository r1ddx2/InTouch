//
//  MKUserAnnotationView.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/6.
//

import UIKit
import MapKit

class MKUserAnnotationView: MKAnnotationView {
    static let identifier = "\(MKUserAnnotationView.self)"
    // MARK: - Subview
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    // MARK: - View load
    override var annotation: MKAnnotation? {
        willSet {
            guard let customAnnotation = newValue as? ITAnnotation else { return }

            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            // Clear default image
            image = UIImage()

            // Set up the custom image
            imageView.image = customAnnotation.icon
            imageView.frame = CGRect(x: 0, y: 0, width: 30, height: 30) // Adjust the size as needed
            imageView.layer.cornerRadius = imageView.frame.width / 2

            // Add the custom image view to the annotation view
            addSubview(imageView)
        }
    }
}

class ITAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var icon: UIImage?

    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, icon: UIImage?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
    }
}

