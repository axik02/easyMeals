//
//  Categories.swift
//  EasyMeals
//
//  Created by Максим on 3/12/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class Categories: Codable {
    let success: Bool?
    let data: [CategoryData]?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        case success = "success"
        case data = "data"
        case message = "message"
    }
    
    init(success: Bool?, data: [CategoryData]?, message: String?) {
        self.success = success
        self.data = data
        self.message = message
    }
}

class CategoryData: Codable {
    let categoryID: Int?
    let title: String?
    var isSelected: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case categoryID = "categories_id"
        case title = "title"
//        case isSelected = "is_selected"
    }
    
    init(categoryID: Int?, title: String?) {
        self.categoryID = categoryID
        self.title = title
        self.isSelected = false
    }
}

// MARK: Convenience initializers and mutators

extension Categories {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Categories.self, from: data)
        self.init(success: me.success, data: me.data, message: me.message)
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
        success: Bool?? = nil,
        data: [CategoryData]?? = nil,
        message: String?? = nil
        ) -> Categories {
        return Categories(
            success: success ?? self.success,
            data: data ?? self.data,
            message: message ?? self.message
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension CategoryData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(CategoryData.self, from: data)
        self.init(categoryID: me.categoryID, title: me.title)
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
        categoryID: Int?? = nil,
        title: String?? = nil
        ) -> CategoryData {
        return CategoryData(
            categoryID: categoryID ?? self.categoryID,
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
