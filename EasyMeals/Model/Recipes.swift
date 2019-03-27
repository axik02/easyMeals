//
//  Recipe.swift
//  EasyMeals
//
//  Created by Максим on 3/12/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class Recipes: Codable {
    let data: [RecipesData]?
    let currentPage: Int?
    let countOfPages: Int?
    let totalItems: Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case currentPage = "current_page"
        case countOfPages = "count_of_pages"
        case totalItems = "total_items"
    }
    
    init(data: [RecipesData]?, currentPage: Int?, countOfPages: Int?, totalItems: Int?) {
        self.data = data
        self.currentPage = currentPage
        self.countOfPages = countOfPages
        self.totalItems = totalItems
    }
}

class RecipesData: Codable {
    let recipeid: Int?
    let title: String?
    let usersid: Int?
    let files: Files?
    
    enum CodingKeys: String, CodingKey {
        case recipeid = "recipe_id"
        case title = "title"
        case usersid = "users_id"
        case files = "files"
    }
    
    init(recipeid: Int?, title: String?, usersid: Int?, files: Files?) {
        self.recipeid = recipeid
        self.title = title
        self.usersid = usersid
        self.files = files
    }
}

class Files: Codable {
    let filesid: Int?
    let filename: String?
    
    enum CodingKeys: String, CodingKey {
        case filesid = "files_id"
        case filename = "filename"
    }
    
    init(filesid: Int?, filename: String?) {
        self.filesid = filesid
        self.filename = filename
    }
}

// MARK: Convenience initializers and mutators

extension Recipes {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Recipes.self, from: data)
        self.init(data: me.data, currentPage: me.currentPage, countOfPages: me.countOfPages, totalItems: me.totalItems)
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
        data: [RecipesData]?? = nil,
        currentPage: Int?? = nil,
        countOfPages: Int?? = nil,
        totalItems: Int?? = nil
        ) -> Recipes {
        return Recipes(
            data: data ?? self.data,
            currentPage: currentPage ?? self.currentPage,
            countOfPages: countOfPages ?? self.countOfPages,
            totalItems: totalItems ?? self.totalItems
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension RecipesData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(RecipesData.self, from: data)
        self.init(recipeid: me.recipeid, title: me.title, usersid: me.usersid, files: me.files)
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
        recipeid: Int?? = nil,
        title: String?? = nil,
        usersid: Int?? = nil,
        files: Files?? = nil
        ) -> RecipesData {
        return RecipesData(
            recipeid: recipeid ?? self.recipeid,
            title: title ?? self.title,
            usersid: usersid ?? self.usersid,
            files: files ?? self.files
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension Files {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Files.self, from: data)
        self.init(filesid: me.filesid, filename: me.filename)
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
        filesid: Int?? = nil,
        filename: String?? = nil
        ) -> Files {
        return Files(
            filesid: filesid ?? self.filesid,
            filename: filename ?? self.filename
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
