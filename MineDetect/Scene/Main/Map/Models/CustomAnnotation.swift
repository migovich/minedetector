//
//  CustomAnnotation.swift
//  MineDetect
//
//  Created by Migovich on 24.09.2022.
//

import MapKit.MKPointAnnotation

class CustomAnnotation: MKPointAnnotation {
    let model: MineModel
    
    init(model: MineModel) {
        self.model = model
    }
}
