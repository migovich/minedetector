//
//  MapManager.swift
//  MineDetect
//
//  Created by Migovich on 24.09.2022.
//

import MapKit

protocol MapManagerDelegate: AnyObject {
    func update(map region: MKCoordinateRegion)
    func update(map annotations: [MKPointAnnotation])
    func setLocationAuthorization(status isGranted: Bool)
}

class MapManager {
    
    // MARK: Dependency Properties
    private let locationService: LocationService = LocationService.shared
    
    // MARK: Stored Properties
    weak var delegate: MapManagerDelegate?
    private let radius: CLLocationDistance = 500
    
    // MARK: Computed Properties
    var mines: [MineModel] = [] {
        didSet {
            delegate?.update(map: annotations)
        }
    }
    
    var currentRegion: MKCoordinateRegion? {
        guard let currentLocation = locationService.currentLocation else {
            return nil
        }
        return getRegion(with: currentLocation)
    }
    
    var annotations: [MKPointAnnotation] {
        return getAnnotations(for: mines)
    }
    
    // MARK: Init
    init() {
        locationService.delegate = self
    }
    
    // MARK: Functions [Get]
    private func getRegion(with location: CLLocation) -> MKCoordinateRegion {
        return MKCoordinateRegion.init(center: location.coordinate,
                                       latitudinalMeters: radius,
                                       longitudinalMeters: radius)
    }
     
    // MARK: Functions [Location]
    func checkLocationAuthorization() {
        locationService.checkLocationAuthorization()
    }
    
    private func getAnnotations(for mines: [MineModel]) -> [MKPointAnnotation] {
        var annotations: [MKPointAnnotation] = []
        mines.forEach { mine in
            let latitude = mine.location.latitude
            let longitude = mine.location.longitude
            let annotation = CustomAnnotation(model: mine)
            annotation.title = mine.type.description
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotations.append(annotation)
        }
        return annotations
    }
}

// MARK: - LocationServiceDelegate
extension MapManager: LocationServiceDelegate {
    func setLocationAuthorization(status isGranted: Bool) {
        delegate?.setLocationAuthorization(status: isGranted)
    }
    
    func setMapRegion(with location: CLLocation) {
        delegate?.update(map: getRegion(with: location))
    }

    func setMapAnnotations() {
        delegate?.update(map: annotations)
    }
}
