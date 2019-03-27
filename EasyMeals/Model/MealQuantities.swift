//
//  MealQuantities.swift
//  EasyMeals
//
//  Created by Максим on 3/26/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class MealQuantities: Codable {
    let data: [QuantityData]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(data: [QuantityData]?) {
        self.data = data
    }
}

class QuantityData: Codable {
    let mealsQuantityid: Int?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case mealsQuantityid = "meals_quantity_id"
        case title = "title"
    }
    
    init(mealsQuantityid: Int?, title: String?) {
        self.mealsQuantityid = mealsQuantityid
        self.title = title
    }
}

// MARK: Convenience initializers and mutators

extension MealQuantities {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MealQuantities.self, from: data)
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
        data: [QuantityData]?? = nil
        ) -> MealQuantities {
        return MealQuantities(
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

extension QuantityData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(QuantityData.self, from: data)
        self.init(mealsQuantityid: me.mealsQuantityid, title: me.title)
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
        title: String?? = nil
        ) -> QuantityData {
        return QuantityData(
            mealsQuantityid: mealsQuantityid ?? self.mealsQuantityid,
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
