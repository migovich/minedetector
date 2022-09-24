//
//  MineModel.swift
//  MineDetect
//
//  Created by Migovich on 24.09.2022.
//

import Foundation
protocol Serializable {
    func serialized() -> String
}

struct MineModel {
    let name: String?
    let description: String?
    let imageUrl: String?
    let location: Location
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

extension Location: Serializable {
    func serialized() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        var resultString = ""
        do {
            let jsonData = try encoder.encode(self)
            if let json = String(data: jsonData, encoding: .utf8) {
                resultString = json.replacingOccurrences(of: "\\", with: "")
                print(resultString)
            }
        } catch {
            print("error encoding JSON: \(error)")
        }
        return resultString
    }
}
