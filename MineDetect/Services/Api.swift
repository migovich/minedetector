//
//  Api.swift
//  MineDetect
//
//  Created by vitalii on 23.09.2022.
//

import Foundation
import UIKit


class APIHandler: NSObject {
    static func signup(_ requestModel: SignupRequestModel, _ completion: @escaping ((LoginResponseModel?) -> ())) {
            call(ACRequest.signup(requestModel))
            .decoded(as: LoginResponseModel.self, using: JSONDecoder())
            .observe { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        completion(data)
                    case .failure(_):
                        completion(nil)
                    }
                }
            }
    }
    
    static func login(_ requestModel: LoginRequestModel, _ completion: @escaping ((LoginResponseModel?) -> ())) {
        call(ACRequest.login(requestModel))
            .decoded(as: LoginResponseModel.self, using: JSONDecoder())
            .observe { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        completion(data)
                    case .failure(_):
                        completion(nil)
                    }
                }
            }
    }
    
    static func getMines(_ requestModel: MinesRequestModel, _ completion: @escaping ((MinesResponseModel?) -> ())) {
        call(ACRequest.getMines(requestModel))
            .decoded(as: MinesResponseModel.self, using: JSONDecoder())
            .observe { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        completion(data)
                    case .failure(_):
                        completion(nil)
                    }
                }
            }
    }
    
    static func getMineDetails(_ id: String, _ completion: @escaping ((MinesElementResponseModel?) -> ())) {
        call(ACRequest.getMineDetails(id))
            .decoded(as: MinesElementResponseModel.self, using: JSONDecoder())
            .observe { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        completion(data)
                    case .failure(_):
                        completion(nil)
                    }
                }
            }
    }
    
    static func getUser(_ requestModel: GetUserRequestModel, _ completion: @escaping ((GetUserResponseModel?) -> ())) {
        call(ACRequest.getUser(requestModel))
            .decoded(as: GetUserResponseModel.self, using: JSONDecoder())
            .observe { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        completion(data)
                    case .failure(_):
                        completion(nil)
                    }
                }
            }
    }
    
    static func addMine(_ requestModel: AddMineRequestModel, _ completion: @escaping ((AddMineResponseModel?) -> ())) {
        upload(ACRequest.addMine(requestModel))
            .decoded(as: AddMineResponseModel.self, using: JSONDecoder())
            .observe { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        completion(data)
                    case .failure(_):
                        completion(nil)
                    }
                }
            }
    }
    
    
}

extension APIHandler {
   static func call(_ route: ACRequest) -> Future<Data> {
        return URLSession.shared.request(request: route.request)
    }
    
    static func upload(_ route: ACRequest) -> Future<Data> {
        return URLSession.shared.upload(request: route.request, fromData: route.fromData ?? Data())
    }
}

struct ACRequestData {
    var path: String?
    var route: String?
    var method = "GET"
    var body: Data?
    var headers: [String: String]?
    var queries: [URLQueryItem]?
    var fromData: Data?
}
let PORT = 4000
let HOST = "3.15.199.210"

class ACRequest {
    var baseComponents: URLComponents? {
        var temp = URLComponents()
        temp.scheme = "http"
        temp.host = HOST
        temp.port = PORT
        temp.path = "/api"
        return temp
    }
    static let headers = ["Content-Type": "application/json"]
    var fromData: Data?
    var request: URLRequest!
    var token: String? {
        didSet {
            request?.addValue("Bearer \(self.token ?? "")", forHTTPHeaderField: "Authorization")
        }
    }
    init(_ data: ACRequestData, _ host: String? = nil) {
        fromData = data.fromData
        
        var comps = baseComponents
        if let host = host {
            comps?.host = host
        }
        comps?.queryItems = data.queries
        if let route = data.route, var url = comps?.url {
            url.appendPathComponent(route)
            request = URLRequest(url: url)
            request?.httpMethod = data.method
            request?.httpBody = data.body
            data.headers?.forEach {
                request.addValue($1, forHTTPHeaderField: $0)
            }
            
        } else if let path = data.path, var components = comps {
            components.path = path
            guard let url = components.url else {
                print("ACRequest ERROR: could not make url with path: \(path)")
                return
            }
            request = URLRequest(url: url)
            request?.httpMethod = data.method
            request?.httpBody = data.body
            data.headers?.forEach {
                request.addValue($1, forHTTPHeaderField: $0)
            }
        }
    }
    
    //    var parse: ((Data) -> T)?
    static func updateUser(_ user: User) -> ACRequest {
        let data = ACRequestData(route: "profile",
                                 method: "PUT",
                                 body: try? JSONEncoder().encode(user),
                                 headers: headers)
        return ACRequest(data)
    }
    static var fetchUser: ACRequest {
        let data = ACRequestData(route: "profile")
        let request = ACRequest(data)
        //        request.parse = { data in
        //            return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
        //        }
        return request
    }
    
    static func addMine(_ requestModel: AddMineRequestModel) -> ACRequest {
        let form = MultipartForm(parts: [
            MultipartForm.Part(name: "title", value: requestModel.title),
            MultipartForm.Part(name: "userdId", value: requestModel.userdID),
            MultipartForm.Part(name: "description", value: requestModel.description),
            MultipartForm.Part(name: "location", value: requestModel.location.serialized()),
            MultipartForm.Part(name: "file", data: requestModel.image, filename: "1.png", contentType: "image/png"),
        ])

        let data = ACRequestData(path: "/api/mines",
                                 method: "POST",
                                 headers: ["Content-Type": form.contentType],
                                 fromData: form.bodyData)
        return ACRequest(data)
    }
    
    static func getMines(_ requestModel: MinesRequestModel) -> ACRequest {
        let data = ACRequestData(path: "/api/mines/metadata",
                                 method: "POST",
                                 body: try? JSONEncoder().encode(requestModel),
                                 headers: headers)
        return ACRequest(data)
    }
    
    static func signup(_ requestModel: SignupRequestModel) -> ACRequest {
        let data = ACRequestData(path: "/api/user/mobile/signUp",
                                 method: "POST",
                                 body: try? JSONEncoder().encode(requestModel),
                                 headers: headers)
        return ACRequest(data)
    }
    
    static func login(_ requestModel: LoginRequestModel) -> ACRequest {
        let data = ACRequestData(path: "/api/user/login",
                                 method: "POST",
                                 body: try? JSONEncoder().encode(requestModel),
                                 headers: headers)
        return ACRequest(data)
    }
    
    static func getUser(_ requestModel: GetUserRequestModel) -> ACRequest {
        let data = ACRequestData(path: "/api/user/getUser",
                                 method: "GET",
                                 headers: headers,
                                 queries: [
                                    URLQueryItem(name: "userName", value: requestModel.userName)
                                 ])
        return ACRequest(data)
    }

    static func getMineDetails(_ id: String) -> ACRequest {
        let data = ACRequestData(path: "/api/mines/" + id,
                                 method: "GET",
                                 headers: headers)
        return ACRequest(data)
    }
    
    static func requestCallback(_ requestModel: RequestModel) -> ACRequest {
        let data = ACRequestData(path: "/api/mobile/v1/requestCallback",
                                 method: "POST",
                                 body: try? JSONEncoder().encode(requestModel),
                                 headers: headers)
        return ACRequest(data)
    }
    
}

struct RequestModel: Codable {
    
}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key, value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
    
    func convert<T: Decodable>(_ t: T.Type) -> T? {
        if let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted) {
            return try? JSONDecoder().decode(t, from: data)
        }
        return nil
    }
}

class BaseResponseModel: Codable {
    let error: String?
    let statusCode: Int?
    let message: [String]?
}

class BaseRequest<T>: NSObject {
    let url: URL?
    
    init(_ url: URL?) {
        self.url = url
    }
    
    init(_ string: String?) {
        self.url = URL(string: string ?? "")
    }
    
    var parser: ((Data) -> T?)! {
        return {
            return $0 as? T
        }
    }
}

class ImageRequest: BaseRequest<UIImage> {
    override var parser: ((Data) -> UIImage?)! {
        return {
            return UIImage(data: $0)
        }
    }
}

class Future<Value> {
    typealias Result = Swift.Result<Value, Error>
    
    fileprivate var result: Result? {
        // Observe whenever a result is assigned, and report it:
        didSet { result.map(report) }
    }
    private var callbacks = [(Result) -> Void]()
    
    func observe(using callback: @escaping (Result) -> Void) {
        // If a result has already been set, call the callback directly:
        if let result = result {
            return callback(result)
        }
        
        callbacks.append(callback)
    }
    
    private func report(result: Result) {
        callbacks.forEach { $0(result) }
        callbacks = []
    }
}

class Promise<Value>: Future<Value> {
    init(value: Value? = nil) {
        super.init()
        
        // If the value was already known at the time the promise
        // was constructed, we can report it directly:
        result = value.map(Result.success)
    }
    
    func resolve(with value: Value) {
        result = .success(value)
    }
    
    func reject(with error: Error) {
        result = .failure(error)
    }
}

extension Future {
    func chained<T>(
        using closure: @escaping (Value) throws -> Future<T>
    ) -> Future<T> {
        // We'll start by constructing a "wrapper" promise that will be
        // returned from this method:
        let promise = Promise<T>()
        
        // Observe the current future:
        observe { result in
            switch result {
            case .success(let value):
                do {
                    // Attempt to construct a new future using the value
                    // returned from the first one:
                    let future = try closure(value)
                    
                    // Observe the "nested" future, and once it
                    // completes, resolve/reject the "wrapper" future:
                    future.observe { result in
                        switch result {
                        case .success(let value):
                            promise.resolve(with: value)
                        case .failure(let error):
                            promise.reject(with: error)
                        }
                    }
                } catch {
                    promise.reject(with: error)
                }
            case .failure(let error):
                promise.reject(with: error)
            }
        }
        
        return promise
    }
}

extension Future {
    func transformed<T>(
        with closure: @escaping (Value) throws -> T
    ) -> Future<T> {
        chained { value in
            try Promise(value: closure(value))
        }
    }
}

extension URLSession {
    func request(request: URLRequest) -> Future<Data> {
        // We'll start by constructing a Promise, that will later be
        // returned as a Future:
        let promise = Promise<Data>()
        
        // Perform a data task, just like we normally would:
        let task = dataTask(with: request) { data, _, error in
            // Reject or resolve the promise, depending on the result:
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: data ?? Data())
            }
        }
        
        task.resume()
        
        return promise
    }
    
    func upload(request: URLRequest, fromData: Data) -> Future<Data> {
        // We'll start by constructing a Promise, that will later be
        // returned as a Future:
        let promise = Promise<Data>()
        
        // Perform a data task, just like we normally would:
        let task = uploadTask(with: request, from: fromData) { data, _, error in
            // Reject or resolve the promise, depending on the result:
            if let error = error {
                promise.reject(with: error)
            } else {
                promise.resolve(with: data ?? Data())
            }
        }
        
        task.resume()
        
        return promise
    }
}

extension Future where Value == Data {
    func decoded<T: Decodable>(
        as type: T.Type = T.self,
        using decoder: JSONDecoder = .init()
    ) -> Future<T> {
        transformed { data in
            // TODO: need to make check of status code fitst and then attemt to parse or return failed
            // in case of statusCode == 200 backend may return empty body which is not JSON object.
            // if data is empty then we put empty JSON object inside so that it could be parsed
            let emptyJSONObject = data.isEmpty ? "{}".data(using: .utf8) : data
            return try decoder.decode(T.self, from: emptyJSONObject ?? data)
        }
    }
    
    
}

