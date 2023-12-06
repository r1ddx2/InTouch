//
//  MapViewController.swift
//  InTouch
//
//  Created by Red Wang on 2023/11/17.
//
import UIKit
import MapKit
import CoreLocation

class MapViewController: ITBaseViewController {
    private let firestoreManager = FirestoreManager.shared
    
    var user: User?
    
    // MARK: - Subviews
    var mapView = MKMapView()
    
    let manager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    let currentLocationButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(resource: .iconCurrentLocation).withRenderingMode(.alwaysOriginal), for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.2
        return button
    }()
    // MARK: - View Load
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpLocationManager()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayouts()
        setUpActions()
        fetchUserData()
    }
    private func setUpLayouts() {
        view.addSubview(mapView)
        view.addSubview(currentLocationButton)
        mapView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view)
        }
        currentLocationButton.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.trailing.equalTo(view).offset(-20)
        }
    }
    private func setUpActions() {
        currentLocationButton.addTarget(self, action: #selector(goToUserLocation), for: .touchUpInside)
    }
    private func setUpLocationManager() {
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        mapView.showsBuildings = false
        // mapView.delegate = self
    }
    
    
    // MARK: - Methods
    private func fetchUserData() {
        firestoreManager.getDocument(
            asType: User.self,
            documentId: FakeData.userRed.userId,
            reference: firestoreManager.getRef(.users, group: nil)) { result in
                switch result {
                case .success(let user):
                    self.user = user
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                }
                
            }
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
    func render(_ location: CLLocation){
        
        let coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        
        mapView.setRegion(region, animated: true)

        showUserPin(coordinate)
        //addUserPin(coordinate)
    }
    func showUserPin(_ coordinate: CLLocationCoordinate2D) {
        let pin = MKPointAnnotation()
        pin.title = "Red"
        pin.coordinate = coordinate
        mapView.addAnnotation(pin)
    }
    @objc private func goToUserLocation() {
        if let userLocation = manager.location {
            let userCoordinate = userLocation.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: userCoordinate, span: span)
            mapView.setRegion(region, animated: true)
            showUserPin(userCoordinate)
        }
    }
    
}
//
//extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        guard !(annotation is MKUserLocation) else { return nil }
//
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKUserAnnotationView.identifier) as? MKUserAnnotationView
//        if annotationView == nil {
//            annotationView = MKUserAnnotationView(annotation: annotation, reuseIdentifier: "custom")
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//        return annotationView
//    }
//
//    func downloadUserIcon(completion: @escaping (UIImage?) -> Void) {
//
//        guard let user = user else {
//            completion(nil)
//            return
//        }
//
//        KingFisherWrapper.shared.downloadImage(url: user.userIcon) { result in
//            switch result {
//            case .success(let icon):
//                completion(icon)
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//                completion(nil)
//            }
//        }
//    }
//
//}
