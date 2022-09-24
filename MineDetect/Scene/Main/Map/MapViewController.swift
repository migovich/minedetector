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
    
    @objc func didClickDetailDisclosure(sender: MineInfoTapGestureRecognizer) {
        performSegue(withIdentifier: "presentMineInfo", sender: sender.model)
    }
    
    // MARK: Helpers
    class MineInfoTapGestureRecognizer: UITapGestureRecognizer {
        var model: MineModel?
    }
}

// MARK: - Navigation
extension MapViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? MineInfoViewController,
           let mine = sender as? MineModel {
            controller.model = MineInfoViewController.Model(title: mine.name,
                                                            description: mine.description,
                                                            imageUrl: mine.imageUrl)
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        if let customAnnotation = annotation as? CustomAnnotation {
            let annotationView = MapMineAnnotationView(annotation: annotation, reuseIdentifier: MapMineAnnotationView.className)
            let rightButton = UIButton(type: .detailDisclosure)
            let tapGesture = MineInfoTapGestureRecognizer(target: self, action: #selector(didClickDetailDisclosure(sender:)))
            tapGesture.model = customAnnotation.model
            rightButton.addGestureRecognizer(tapGesture)
            annotationView.rightCalloutAccessoryView = rightButton
            return annotationView
        }
        return nil
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
