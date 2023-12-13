//
//  MapDetailViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/12/12.
//

import UIKit
import UIKit
import MapKit
import CoreLocation

class MapDetailViewController: ITBaseViewController {
    var annotation: ITAnnotation?
    var currentLocation: CLLocationCoordinate2D?
    
    // MARK: - Subviews
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 16
       // view.borderColor = .ITYellow
       // view.borderWidth = 3
        return view
    }()
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.cornerRadius = 100
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.borderColor = .ITYellow
        imageView.borderWidth = 6
        return imageView
    }()
    let placeLabel: UILabel = {
        let label = UILabel()
        label.font = .bold(size: 20)
        label.textColor = .ITBlack
        return label
    }()
    let distanceLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 18)
        label.textColor = .ITDarkGrey
        return label
    }()
    let captionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 18)
        label.textColor = .ITBlack
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    let userIdLabel: UILabel = {
        let label = UILabel()
        label.font = .regular(size: 16)
        label.textColor = .ITDarkGrey
        label.textAlignment = .center
        return label
    }()
    // MARK: - View Load
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setUpLayouts()
        layoutPage()
    }
    private func setUpLayouts() {
        view.addSubview(backgroundView)
        view.addSubview(imageView)
        backgroundView.addSubview(placeLabel)
        backgroundView.addSubview(distanceLabel)
        backgroundView.addSubview(captionLabel)
        backgroundView.addSubview(userIdLabel)
        
        backgroundView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(100)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        imageView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.height.width.equalTo(200)
            make.centerX.equalTo(backgroundView.snp.centerX)
        }
        placeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(imageView.snp.bottom).offset(32)
            make.centerX.equalTo(backgroundView.snp.centerX)
        }
        distanceLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(placeLabel.snp.bottom).offset(8)
            make.centerX.equalTo(backgroundView.snp.centerX)
        }
        captionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(distanceLabel.snp.bottom).offset(24)
            make.centerX.equalTo(backgroundView.snp.centerX)
        }
        userIdLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(captionLabel.snp.bottom).offset(8)
            make.centerX.equalTo(backgroundView.snp.centerX)
        }
        
    }
    
    // MARK: - Methods
    private func layoutPage() {
        guard let annotation = annotation, 
        let currentLocation = currentLocation,
        let userId = annotation.title else { return }
        imageView.loadImage(annotation.imageBlock?.image)
        placeLabel.text = annotation.imageBlock?.place
        let distance = annotation.coordinate.distance(to: currentLocation)
        distanceLabel.text = "\(distance)km"
        captionLabel.text = annotation.imageBlock?.caption
        userIdLabel.text = "--- \(userId)"
        
        
    }
}
