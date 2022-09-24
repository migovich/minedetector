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

extension Data {
    mutating func append(_ string: String) {
        self.append(string.data(using: .utf8, allowLossyConversion: true)!)
    }
}
