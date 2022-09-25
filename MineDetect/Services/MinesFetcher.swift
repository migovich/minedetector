//
//  MinesFetcher.swift
//  MineDetect
//
//  Created by vitalii on 24.09.2022.
//

import Foundation

protocol MinesFetcherDelegate: AnyObject {
    func didFetchMines(_ data: [MineModel])
}

class MinesFetcher: NSObject {
    static let shared = MinesFetcher()
    private var fetchMinesWorkItem: DispatchWorkItem?
    var fetchDelay: Double = 60 * 1
    
    weak var minesFetcherDelegate: MinesFetcherDelegate? {
        didSet {
            fetchMinesLoop()
        }
    }
    private override init() {
        super.init()
    }
    
    private func fetchMinesLoop() {
        if minesFetcherDelegate == nil { return }
        
        fetchMinesWorkItem?.cancel()
        
        fetchMines()
        
        let workItem = DispatchWorkItem { [weak self] in
            self?.fetchMines {
                self?.fetchMinesLoop()
            }
        }
        
        fetchMinesWorkItem = workItem
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + fetchDelay,
                                                             execute: workItem)
    }
    
    func stopFetchingMines() {
        fetchMinesWorkItem?.cancel()
    }
    
    func startFetchingMines() {
        fetchMinesLoop()
    }
    
    func fetchMines(_ completion: (() -> Void)? = nil) {
        let minesRequestModel = MinesRequestModel(userID: "632ef0e8d628897e69af8fa8",
                                                  location: LocationService.shared.location,
                                                  radius: 1)
        APIHandler.getMines(minesRequestModel) { [weak self] response in
            print(response ?? "⚠️ APIHandler.getMines response is nil")
            if let response = response {
                DispatchQueue.main.async {
                    var mines: [MineModel] = []
                    response.forEach { element in
                        mines.append(MineModel(type: MineType(rawValue: element.typeID) ?? .other, mineID: element.mineID, location: element.location))
                    }
                    self?.minesFetcherDelegate?.didFetchMines(mines)
                }
            }
        }
    }
}
