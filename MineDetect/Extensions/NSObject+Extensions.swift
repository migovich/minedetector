//
//  NSObject+Extensions.swift
//  MineDetect
//
//  Created by Migovich on 23.09.2022.
//

import Foundation

extension NSObject {
    class var className: String {
        return String(describing: self)
    }
}
