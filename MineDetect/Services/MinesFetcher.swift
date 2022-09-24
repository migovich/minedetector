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
    
    private let mockMines: [MineModel] = [
        MineModel(name: "Mine", location: Location(latitude: 50.4538916, longitude: 30.4773090)),
        MineModel(name: "Bomb", location: Location(latitude: 50.4539439, longitude: 30.4758224)),
        MineModel(name: "Unknown", location: Location(latitude: 50.4559810, longitude: 30.4794799)),
        MineModel(name: "Granade", location: Location(latitude: 50.4507702, longitude: 30.4825436))
    ]
    
    func fetchMines(_ completion: (() -> Void)? = nil) {
        APIHandler.getMines(MinesRequestModel()) { [weak self] response in
            print(response)
            if let response = response,
                let mockMines = self?.mockMines {
                DispatchQueue.main.async {
                    self?.minesFetcherDelegate?.didFetchMines(mockMines)
                }
            }
        }
    }
}
