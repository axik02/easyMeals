//
//  User.swift
//  EasyMeals
//
//  Created by Максим on 2/22/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation
//import Alamofire

class User: Codable {
    let data: UserData?
    let jwtToken: String?
    let refreshToken: String?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case jwtToken = "jwt_token"
        case refreshToken = "refresh_token"
    }
    
    init(data: UserData?, jwtToken: String?, refreshToken: String?) {
        self.data = data
        self.jwtToken = jwtToken
        self.refreshToken = refreshToken
    }
}

class UserData: Codable {
    let usersID: Int?
    let userName: String?
    let qrCode: String?
    let qrCodeFilename: String?
    let email: String?
    let settings: UserSettings?
    let createdAt: Int?
    
    enum CodingKeys: String, CodingKey {
        case usersID = "users_id"
        case userName = "user_name"
        case qrCode = "qr_code"
        case qrCodeFilename = "qr_code_filename"
        case email = "email"
        case settings = "settings"
        case createdAt = "created_at"
    }
    
    init(usersID: Int?, userName: String?, qrCode: String?, qrCodeFilename: String?, email: String?, settings: UserSettings?, createdAt: Int?) {
        self.usersID = usersID
        self.userName = userName
        self.qrCode = qrCode
        self.qrCodeFilename = qrCodeFilename
        self.email = email
        self.settings = settings
        self.createdAt = createdAt
    }
}

class UserSettings: Codable {
    let mealsQuantityid: Int?
    let mealsVarietyid: Int?
    
    enum CodingKeys: String, CodingKey {
        case mealsQuantityid = "meals_quantity_id"
        case mealsVarietyid = "meals_variety_id"
    }
    
    init(mealsQuantityid: Int?, mealsVarietyid: Int?) {
        self.mealsQuantityid = mealsQuantityid
        self.mealsVarietyid = mealsVarietyid
    }
}

// MARK: Convenience initializers and mutators

extension User {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(User.self, from: data)
        self.init(data: me.data, jwtToken: me.jwtToken, refreshToken: me.refreshToken)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        data: UserData?? = nil,
        jwtToken: String?? = nil,
        refreshToken: String?? = nil
        ) -> User {
        return User(
            data: data ?? self.data,
            jwtToken: jwtToken ?? self.jwtToken,
            refreshToken: refreshToken ?? self.refreshToken
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension UserData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(UserData.self, from: data)
        self.init(usersID: me.usersID, userName: me.userName, qrCode: me.qrCode, qrCodeFilename: me.qrCodeFilename, email: me.email, settings: me.settings, createdAt: me.createdAt)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        usersID: Int?? = nil,
        userName: String?? = nil,
        qrCode: String?? = nil,
        qrCodeFilename: String?? = nil,
        email: String?? = nil,
        settings: UserSettings?? = nil,
        createdAt: Int?? = nil
        ) -> UserData {
        return UserData(
            usersID: usersID ?? self.usersID,
            userName: userName ?? self.userName,
            qrCode: qrCode ?? self.qrCode,
            qrCodeFilename: qrCodeFilename ?? self.qrCodeFilename,
            email: email ?? self.email,
            settings: settings ?? self.settings,
            createdAt: createdAt ?? self.createdAt
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension UserSettings {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(UserSettings.self, from: data)
        self.init(mealsQuantityid: me.mealsQuantityid, mealsVarietyid: me.mealsVarietyid)
    }
    
    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }
    
    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }
    
    func with(
        mealsQuantityid: Int?? = nil,
        mealsVarietyid: Int?? = nil
        ) -> UserSettings {
        return UserSettings(
            mealsQuantityid: mealsQuantityid ?? self.mealsQuantityid,
            mealsVarietyid: mealsVarietyid ?? self.mealsVarietyid
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

fileprivate func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

fileprivate func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - Alamofire response handlers

//extension DataRequest {
//
//    func newJSONDecoder() -> JSONDecoder {
//        let decoder = JSONDecoder()
//        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//            decoder.dateDecodingStrategy = .iso8601
//        }
//        return decoder
//    }
//
//    func newJSONEncoder() -> JSONEncoder {
//        let encoder = JSONEncoder()
//        if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
//            encoder.dateEncodingStrategy = .iso8601
//        }
//        return encoder
//    }
//
//    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
//        return DataResponseSerializer { _, response, data, error in
//            guard error == nil else { return .failure(error!) }
//
//            guard let data = data else {
//                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
//            }
//
//            return Result { try self.newJSONDecoder().decode(T.self, from: data) }
//        }
//    }
//
//    @discardableResult
//    fileprivate func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
//        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
//    }
//
//    @discardableResult
//    func responseUser(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<User>) -> Void) -> Self {
//        return responseDecodable(queue: queue, completionHandler: completionHandler)
//    }
//}
