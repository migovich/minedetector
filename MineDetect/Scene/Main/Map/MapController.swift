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
    
    // MARK: Stored Properties
    var mines: [MineModel] {
        return [
            MineModel(name: "Протипіхотна осколкова міна ПОМЗ", description: "За словами Тетяни Вельшиної, одна з найнебезпечніших осколкових мін — ОЗМ-72: За розміром вона, як літрова банка. Важить 5 кілограмів. Усередині має 2400 осколків, які розлітаються на 50 метрів. Людина зачіпає розтяжку, міна вистрибує на висоту 1 метр через ”вишибний” заряд і тоді розривається корпус. Шансів вижити майже немає. \nПротипіхотні міни заборонені Оттавською конвенцією із 1999 року.", imageUrl: "https://cdn4.suspilne.media/images/resize/1040x1.78/8c1ee21fdb2f0eb7.jpg", location: Location(latitude: 50.4538916, longitude: 30.4773090)),
            MineModel(name: "Протитранспортна міна ТМ-62", description: "Часто під протитранспортні міни можуть встановлювати протипіхотні. У разі вибуху — шансів вижити практично немає.", imageUrl: "https://cdn4.suspilne.media/images/resize/1040x1.78/d3e717eb3b36a8e7.jpg", location: Location(latitude: 50.4539439, longitude: 30.4758224)),
            MineModel(name: "Міна “Метелик”", description: "Особливу небезпеку становить міна ”Метелик” (також її називають ”Пелюстка”, — ред.). Ці міни розміром у 12 сантиметрів і вагою близько 80 грамів кожна розкидають із касетних боєприпасів. Вони розриваються або при контакті, або мають часовий детонатор, тобто елемент самоліквідації. Через кілька годин міна може самостійно вибухнути, — каже Тетяна Вельшина.", imageUrl: "https://cdn4.suspilne.media/images/resize/1040x1.78/05604f6932736e1b.jpg", location: Location(latitude: 50.4559810, longitude: 30.4794799))
        ]
    }
    
    // MARK: Dependency Properties
    private weak var view: MapViewProtocol?
    private let manager = MapManager()
    
    // MARK: Life Cycle
    init(with view: MapViewProtocol) {
        self.view = view
        self.manager.delegate = self
        self.manager.mines = mines
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

