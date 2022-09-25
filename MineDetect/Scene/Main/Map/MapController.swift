//
//  MapController.swift
//  MineDetect
//
//  Created by Migovich on 24.09.2022.
//

import MapKit

protocol MapViewProtocol: AnyObject {
    func update(map coordinate: CLLocationCoordinate2D)
    func update(map region: MKCoordinateRegion)
    func update(map annotations: [MKPointAnnotation])
}

class MapController {
    
    // MARK: Dependency Properties
    private weak var view: MapViewProtocol?
    private let manager = MapManager()
    
    // MARK: Life Cycle
    init(with view: MapViewProtocol) {
        self.view = view
        self.manager.delegate = self
        self.manager.checkLocationAuthorization()
        MinesFetcher.shared.minesFetcherDelegate = self
    }
    
    func updateViews() {
        view?.update(map: manager.annotations)
        if let region = manager.currentRegion {
            view?.update(map: region)
        }
    }
}

extension MapController: MapManagerDelegate {
    func update(map region: MKCoordinateRegion) {
        view?.update(map: region)
    }
    
    func update(map annotations: [MKPointAnnotation]) {
        view?.update(map: annotations)
    }
    
    func setLocationAuthorization(status isGranted: Bool) {
        if isGranted {
            updateViews()
        }
    }
}

extension MapController: MinesFetcherDelegate {
    func didFetchMines(_ data: [MineModel]) {
        manager.mines = data
    }
}

