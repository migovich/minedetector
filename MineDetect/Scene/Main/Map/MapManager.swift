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
    var mines: [MineModel] {
        return [
            MineModel(name: "Mine", location: Location(latitude: 50.4538916, longitude: 30.4773090)),
            MineModel(name: "Bomb", location: Location(latitude: 50.4539439, longitude: 30.4758224)),
            MineModel(name: "Unknown", location: Location(latitude: 50.4559810, longitude: 30.4794799)),
            MineModel(name: "Granade", location: Location(latitude: 50.4507702, longitude: 30.4825436))
        ]
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
            if let latitude = mine.location.latitude,
               let longitude = mine.location.longitude {
                let annotation = MKPointAnnotation()
                annotation.title = mine.name
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                annotations.append(annotation)
            }
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
