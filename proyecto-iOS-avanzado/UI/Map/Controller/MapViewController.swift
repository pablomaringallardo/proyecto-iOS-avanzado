//
//  MapViewController.swift
//  proyecto-iOS-avanzado
//
//  Created by Pablo Marín Gallardo on 27/10/23.
//

import UIKit
import MapKit

// MARK: - PROTOCOLO -
protocol MapViewControllerDelegate {
    var viewState: ((MapViewState) -> Void)? { get set }
    var locationsHeros: [LocationDAO] { get set }
    func onViewAppear()
}

// MARK: - Enum view state -
enum MapViewState {
    case update(locations: [LocationDAO])
}

// MARK: - CLASS -
class MapViewController: UIViewController, CLLocationManagerDelegate {
    
//    MARK: - Dependencies -
    var viewModel: MapViewControllerDelegate?
    var locationManager = CLLocationManager()
    
//    MARK: - Outlets -
    @IBOutlet weak var mapView: MKMapView!
    
//    MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        setObserver()
        viewModel?.onViewAppear()

        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.delegate = self
        
    }
    
//    MARK: - Private functions -
    private func setObserver() {
        viewModel?.viewState = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .update(let locations):
                    self?.updateViews(heroLocations: locations)
                }
            }
        }
    }
    
    private func updateViews(heroLocations: [LocationDAO]) {
        
        heroLocations.forEach {
            mapView.addAnnotation(
                HeroAnnotation(
                    coordinate: .init(
                        latitude: Double($0.latitude ?? "") ?? 0.0,
                        longitude: Double($0.longitude ?? "") ?? 0.0
                    )
                )
            )
        }
    }
}
