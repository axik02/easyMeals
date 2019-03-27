//
//  MealVarieties.swift
//  EasyMeals
//
//  Created by Максим on 3/26/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class MealVarieties: Codable {
    let data: [VarietyData]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(data: [VarietyData]?) {
        self.data = data
    }
}

class VarietyData: Codable {
    let mealsVarietyid: Int?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case mealsVarietyid = "meals_variety_id"
        case title = "title"
    }
    
    init(mealsVarietyid: Int?, title: String?) {
        self.mealsVarietyid = mealsVarietyid
        self.title = title
    }
}

// MARK: Convenience initializers and mutators

extension MealVarieties {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MealVarieties.self, from: data)
        self.init(data: me.data)
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
        data: [VarietyData]?? = nil
        ) -> MealVarieties {
        return MealVarieties(
            data: data ?? self.data
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension VarietyData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(VarietyData.self, from: data)
        self.init(mealsVarietyid: me.mealsVarietyid, title: me.title)
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
        mealsVarietyid: Int?? = nil,
        title: String?? = nil
        ) -> VarietyData {
        return VarietyData(
            mealsVarietyid: mealsVarietyid ?? self.mealsVarietyid,
            title: title ?? self.title
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
