//
//  MapViewController.swift
//  MineDetect
//
//  Created by Migovich on 23.09.2022.
//

import UIKit
import MapKit

class MapViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Dependency Properties
    private lazy var controller = MapController(with: self)
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        controller.updateViews()
    }
    
    // MARK: Actions
    @IBAction func detailsButtonPressed(_ sender: UIButton) {
        print(#function)
    }
    
    @objc func didClickDetailDisclosure(button: UIButton) {
        print(#function)
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let annotationView = MapMineAnnotationView(annotation: annotation, reuseIdentifier: MapMineAnnotationView.className)
        let rightButton = UIButton(type: .detailDisclosure)
        rightButton.addTarget(self, action: #selector(didClickDetailDisclosure(button:)), for: .touchUpInside)
        annotationView.rightCalloutAccessoryView = rightButton
        return annotationView
    }
}

// MARK: - MapViewProtocol
extension MapViewController: MapViewProtocol {
    func update(map coordinate: CLLocationCoordinate2D) {
        mapView.setCenter(coordinate, animated: true)
    }
    
    func update(map region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    func update(map annotations: [MKPointAnnotation]) {
        annotations.forEach { annotation in
            if let annotationToRemove = mapView.annotations.first(where: { $0.title == annotation.title
            }) {
                mapView.removeAnnotation(annotationToRemove)
            }
        }
        mapView.addAnnotations(annotations)
    }
}
