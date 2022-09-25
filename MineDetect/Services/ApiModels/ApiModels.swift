//
//  ApiModels.swift
//  MineDetect
//
//  Created by vitalii on 24.09.2022.
//

import Foundation

struct ResponseModel: Codable {
    
}

// MARK: - AddMineResponseModel
struct AddMineResponseModel: Codable {
    let title, addMineResponseModelDescription, status, id: String
    let photoURL: String
    let score: Double
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case title
        case addMineResponseModelDescription = "description"
        case status
        case id = "_id"
        case photoURL = "photoUrl"
        case score
        case v = "__v"
    }
}

// MARK: - AddMineRequestModel
struct AddMineRequestModel {
    let location: Location
    let title, userdID, description: String
    let image: Data
}

// MARK: - MinesModelElement
struct MinesModelElement: Codable {
    let status, id, photoURL, title: String
    let userID, descriptions: String
    
    enum CodingKeys: String, CodingKey {
        case status
        case id = "_id"
        case photoURL = "photoUrl"
        case title
        case userID = "userId"
        case descriptions
    }
}

struct SignupRequestModel: Codable {
    let name: String
    let deviceToken: String
}

struct LoginRequestModel: Codable {
    let userName: String
}

struct GetUserRequestModel: Codable {
    let userName: String
}

struct GetUserResponseModel: Codable {
    let userId: String
}

enum MineType: Int {
    case mine
    case fragment
    case granade
    case parachute
    
    var description: String {
        switch self {
        case .mine: return "Міна"
        case .fragment: return "Снаряд (уламок)"
        case .granade: return "Граната"
        case .parachute: return "Парашют"
        }
    }
}

// MARK: - MinesResponseModelElement
struct MinesResponseModelElement: Codable {
    let location: Location
    let id: String
    let typeID: Int
    let mineID: String
    let v: Int
    
    enum CodingKeys: String, CodingKey {
        case location
        case id = "_id"
        case typeID = "typeId"
        case mineID = "mineId"
        case v = "__v"
    }
    
    var type: MineType {
        return MineType.init(rawValue: typeID) ?? .fragment
    }
}

typealias MinesResponseModel = [MinesResponseModelElement]

struct MinesRequestModel: Codable {
    let userID: String
    let location: Location
    let radius: Int
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case location, radius
    }
}

typealias MinesModel = [MinesModelElement]

