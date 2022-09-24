//
//  MapMineAnnotationView.swift
//  MineDetect
//
//  Created by Migovich on 24.09.2022.
//

import MapKit

class MapMineAnnotationView: MKPinAnnotationView {
    
    var buttonTappedCallBack: (() -> Void)?
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        isDraggable = false
        canShowCallout = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
