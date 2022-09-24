//
//  MineDetectManager.swift
//  MineDetect
//
//  Created by Migovich on 24.09.2022.
//

import Foundation

enum MapState {
    case defaultState
    case pickMine
}

final class MainManager {
    static var shared: MainManager = {
        let instance = MainManager()
        return instance
    }()
    
    // MARK: Stored properties
    var mapState: MapState = .defaultState
    var pendingImageData: Data?
    
    // MARK: Life Cycle
    private init() {}
}
