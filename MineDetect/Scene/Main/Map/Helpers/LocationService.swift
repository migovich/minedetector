//
//  LocationService.swift
//  MineDetect
//
//  Created by Migovich on 24.09.2022.
//

import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func setMapRegion(with location: CLLocation)
    func setMapAnnotations()
    func setLocationAuthorization(status isGranted: Bool)
}

class LocationService: NSObject {
    
    static let shared = LocationService()
    
    // MARK: Dependency properties
    var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    // MARK: Stored properties
    weak var delegate: LocationServiceDelegate?
    
    // MARK: Computed properties
    var currentLocation: CLLocation? {
        return locationManager.location
    }
    
    // MARK: Init
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    // MARK: Functions
    func getAddressFromCoordinate(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        geoCoder.reverseGeocodeLocation(location) { placemarks, _ in
            guard let placemark = placemarks?.first else {
                return
            }
            var address: String = ""
            if let country = placemark.country {
                address += country
            }
            if let city = placemark.locality {
                address += ", \(city)"
            }
            if let street = placemark.thoroughfare {
                address += ", \(street)"
            }
            if let streetLevel = placemark.subThoroughfare {
                address += " \(streetLevel)"
            }
            completion(address)
        }
    }
    
    func getDistanceFromCurrentLocation(to location: CLLocation) -> CLLocationDistance? {
        guard let currentLocation = currentLocation else {
            return nil
        }
        let distanceInMeters = currentLocation.distance(from: location)
        return distanceInMeters
    }
    
    // MARK: Helpers
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            delegate?.setLocationAuthorization(status: true)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            delegate?.setLocationAuthorization(status: false)
        @unknown default:
            break
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        delegate?.setMapRegion(with: location)
        delegate?.setMapAnnotations()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension LocationService {
    var location: Location {
        Location(latitude: currentLocation?.coordinate.latitude ?? 0.0,
                 longitude: currentLocation?.coordinate.longitude ?? 0.0)
    }
}
