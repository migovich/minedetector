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
    @IBOutlet weak var pickMineStackView: UIStackView!
    @IBOutlet weak var pinImageView: UIImageView!
    @IBOutlet weak var footerButtonsStackView: UIStackView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    
    // MARK: Dependency Properties
    private lazy var controller = MapController(with: self)
    private let manager = MainManager.shared
    private var markerLocation: Location?
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        controller.updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    // MARK: Functions
    private func configureView() {
        configureView(with: manager.mapState)
    }
    
    private func configureView(with state: MapState) {
        switch state {
        case .defaultState:
            pinImageView.isHidden = true
            pickMineStackView.isHidden = true
            footerButtonsStackView.isHidden = false
            locationView.isHidden = true
        case .pickMine:
            pinImageView.isHidden = false
            pickMineStackView.isHidden = false
            footerButtonsStackView.isHidden = true
            locationView.isHidden = false
        }
    }
    
    // MARK: Actions
    @IBAction func detailsButtonPressed(_ sender: UIButton) {
        manager.mapState = .pickMine
        configureView()
    }
    
    @IBAction func makePhotoButtonPressed(_ sender: UIButton) {
        manager.mapState = .pickMine
        performSegue(withIdentifier: "takePhoto", sender: nil)
    }
    
    @IBAction func cancelPickMineButtonPressed(_ sender: UIButton) {
        manager.mapState = .defaultState
        manager.pendingImageData = nil
        configureView()
    }
    
    @IBAction func confirmPickMineButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "showMineDetails", sender: nil)
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
        
        if let controller = segue.destination as? MineDetailsViewController {
            controller.location = markerLocation
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print("📍 \(mapView.centerCoordinate)")
        if manager.mapState == .pickMine {
            markerLocation = mapView.centerCoordinate.location
            let latitude = mapView.centerCoordinate.location.latitude
            let longitude = mapView.centerCoordinate.location.longitude
            LocationService.shared.getAddressFromCoordinate(latitude: latitude, longitude: longitude) { [weak self] address in
                self?.locationLabel.text = address
            }
        }
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
