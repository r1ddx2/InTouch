//
//  MKUserAnnotationView.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/6.
//

import UIKit
import MapKit

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
              size: CGSize(width: 45, height: 45)))
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
        self.markerTintColor = .blue
        self.icon = icon
    }
    
   
}

extension UIImage {
    //  image = marker.icon
//      
//       if let iconImage = marker.icon {
//                   // Set a maximum size for the image
//                   let maxImageSize = CGSize(width: 48, height: 48) // Adjust the size as needed
//                   let scaledImage = iconImage.scaledToFit(maxSize: maxImageSize)
//
//                   image = scaledImage
//               }
//       rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//
    func scaledToFit(maxSize: CGSize) -> UIImage {
        let aspectRatio = self.size.width / self.size.height
        var scaledSize = CGSize(width: min(maxSize.width, self.size.width), height: min(maxSize.height, self.size.height))

        if aspectRatio > 1 {
            scaledSize.height = scaledSize.width / aspectRatio
        } else {
            scaledSize.width = scaledSize.height * aspectRatio
        }

        UIGraphicsBeginImageContextWithOptions(scaledSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }

        self.draw(in: CGRect(origin: .zero, size: scaledSize))
        return UIGraphicsGetImageFromCurrentImageContext() ?? self
    }
}
