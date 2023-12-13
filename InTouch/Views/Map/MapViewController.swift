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
    
    var user: User? = KeyChainManager.shared.loggedInUser {
        didSet {
            fetchPosts()
        }
    }
    var markerDatas: [Marker] = []
    var currentLocation: CLLocationCoordinate2D?
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
        fetchUserData()
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
        mapView.delegate = self
        mapView.register(
          MKUserAnnotationView.self,
          forAnnotationViewWithReuseIdentifier:
            MKUserAnnotationView.identifier)
    }
    
    
    // MARK: - Methods
    private func fetchUserData() {
        guard let user = user else { return }
        self.user = nil
        firestoreManager.listenDocument(
            asType: User.self,
            documentId: user.userId,
            reference: firestoreManager.getRef(.users, groupId: nil)) { result in
                switch result {
                case .success(let user):
                    self.user = user
                    KeyChainManager.shared.loggedInUser = user
                    
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    
                }
                
            }
        
    }
    private func fetchPosts() {
        guard let user = user, let userGroups = user.groups else { return }
        let groupIds = userGroups.map { $0.groupId }
        print("Group names: \(groupIds)")
        let documentId = Date().getLastWeekDateRange()
        let references = firestoreManager.getRefs(subCollection: .newsletters, groupIds: groupIds)
        
        let dispatchGroup = DispatchGroup()
        markerDatas.removeAll()
        
        for reference in references {
            dispatchGroup.enter()
            firestoreManager.getDocument(
                asType: NewsLetter.self,
                documentId: documentId,
                reference: reference) { result in
                    
                    defer {
                        dispatchGroup.leave()
                    }
                    
                    switch result {
                    case .success(let newsletter):
                        let posts = newsletter.posts.map { $0 }
                    
                        for post in posts {
                            let imageBlocks = post.imageBlocks
                   
                            for imageBlock in imageBlocks {
                                guard let location = imageBlock.location else { return }
                                let data = Marker(
                                    coordinate: location.toCLLocationCoordinate2D(),
                                    title: post.userName,
                                    subtitle: "Tap to see more",
                                    markerTintColor: .red,
                                    imageBlock: imageBlock
                                )
                                self.markerDatas.append(data)
                            }
                        }
            
                    case .failure(let error):
                        print("Error: \(error)")
                        
                    }
                    
                }
        }
        dispatchGroup.notify(queue: .main) {
            self.addAllPins()
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
     
    }
    func showUserPin(_ coordinate: CLLocationCoordinate2D) {
        currentLocation = coordinate
        let pin = MKPointAnnotation()
        pin.title = "Me"
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
    
    func addAllPins() {
        for markerData in markerDatas {
            
            guard let imageBlock = markerData.imageBlock else { return }
            var icon = UIImage()
            downloadUserIcon(imageString: imageBlock.image) { result in
                switch result {
                case .success(let image):
                    icon = image
                    let customAnnotation = ITAnnotation(
                        coordinate: markerData.coordinate,
                        title: markerData.title,
                        subtitle: markerData.subtitle,
                        imageBlock: markerData.imageBlock,
                        icon: icon
                    )
                    
                    self.mapView.addAnnotation(customAnnotation)
                case .failure(let error):
                    print(error)
                    icon = UIImage(resource: .iconRight)
                    let customAnnotation = ITAnnotation(
                        coordinate: markerData.coordinate,
                        title: markerData.title,
                        subtitle: markerData.subtitle,
                        imageBlock: markerData.imageBlock,
                        icon: icon
                    )
                    
                    self.mapView.addAnnotation(customAnnotation)
                }
            }
           
        }
        
    }
    func downloadUserIcon(imageString: String, completion: @escaping ((Result<UIImage, Error>) -> Void)) {
        
        KingFisherWrapper.shared.downloadImage(url: imageString) { result in
            switch result {
            case .success(let icon):
                completion(.success(icon))
            case .failure(let error):
                completion(.failure(error))
                
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        viewFor annotation: MKAnnotation
      ) -> MKAnnotationView? {
   
        guard let annotation = annotation as? ITAnnotation else {
          return nil
        }

        let identifier = MKUserAnnotationView.identifier
        var view: MKUserAnnotationView
   
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKUserAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
     
          view = MKUserAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
      }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let annotation = view.annotation else {
                return
            }

        
            let zoomedRegion = MKCoordinateRegion(
                center: annotation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            )
            mapView.setRegion(zoomedRegion, animated: true)
        }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            // The detail button was tapped
            if let annotation = view.annotation as? ITAnnotation {
                // Access the data associated with the selected annotation
                let detailVC = MapDetailViewController()
               detailVC.annotation = annotation
                detailVC.currentLocation = currentLocation
                
                if #available(iOS 16.0, *) {
                    if let sheetPresentationController = detailVC.sheetPresentationController {
                        sheetPresentationController.accessibilityRespondsToUserInteraction = true
                        sheetPresentationController.preferredCornerRadius = 16
                        sheetPresentationController.detents = [.custom(resolver: { _ in
                            500
                        })]
                    }
                    present(detailVC, animated: true, completion: nil)
                }
           
                
                
                
                
            }
        }
    }
}
