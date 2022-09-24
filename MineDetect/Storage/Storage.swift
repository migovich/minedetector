//
//  Storage.swift
//  MineDetect
//
//  Created by vitalii on 24.09.2022.
//

import Foundation

class User: Codable {
    var name: String? {
        didSet {
            save()
        }
    }
    var userId: String? {
        didSet {
            save()
        }
    }
    
    var deviceToken: String? {
        didSet {
            save()
        }
    }
    
    static func load() -> User? {
        if let data = UserDefaults.standard.object(forKey: "user") as? Data {
            return try? JSONDecoder().decode(User.self, from: data)
        } else {
            return User()
        }
    }
    
    func save() {
        if let encode = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encode, forKey: "user")
            UserDefaults.standard.synchronize()
        }
    }
}

class Storage: NSObject {
    static let shared = Storage()
    var user: User? {
        didSet {
            user?.save()
        }
    }
    
    private override init() {
        super.init()
        user = User.load()
    }
}
