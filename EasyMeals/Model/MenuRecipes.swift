//
//  MenuRecipes.swift
//  EasyMeals
//
//  Created by Максим on 3/27/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class MenuRecipes: Codable {
    let data: [MenuRecipeData]?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(data: [MenuRecipeData]?) {
        self.data = data
    }
}

class SingleMenuRecipe: Codable {
    let data: MenuRecipeData?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
    
    init(data: MenuRecipeData?) {
        self.data = data
    }
}

class MenuRecipeData: Codable {
    let menuRecipeid: Int?
    let recipeid: Int?
    let recipeTitle: String?
    let usersid: Int?
    let files: Files?
    let categoriesid: Int?
    let categoriesTitle: String?
    
    enum CodingKeys: String, CodingKey {
        case menuRecipeid = "menu_recipe_id"
        case recipeid = "recipe_id"
        case recipeTitle = "recipe_title"
        case usersid = "users_id"
        case files = "files"
        case categoriesid = "categories_id"
        case categoriesTitle = "categories_title"
    }
    
    init(menuRecipeid: Int?, recipeid: Int?, recipeTitle: String?, usersid: Int?, files: Files?, categoriesid: Int?, categoriesTitle: String?) {
        self.menuRecipeid = menuRecipeid
        self.recipeid = recipeid
        self.recipeTitle = recipeTitle
        self.usersid = usersid
        self.files = files
        self.categoriesid = categoriesid
        self.categoriesTitle = categoriesTitle
    }
}

// MARK: Convenience initializers and mutators

extension SingleMenuRecipe {
    
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(SingleMenuRecipe.self, from: data)
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
        data: MenuRecipeData?? = nil
        ) -> SingleMenuRecipe {
        return SingleMenuRecipe(
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

extension MenuRecipes {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MenuRecipes.self, from: data)
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
        data: [MenuRecipeData]?? = nil
        ) -> MenuRecipes {
        return MenuRecipes(
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

extension MenuRecipeData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(MenuRecipeData.self, from: data)
        self.init(menuRecipeid: me.menuRecipeid, recipeid: me.recipeid, recipeTitle: me.recipeTitle, usersid: me.usersid, files: me.files, categoriesid: me.categoriesid, categoriesTitle: me.categoriesTitle)
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
        menuRecipeid: Int?? = nil,
        recipeid: Int?? = nil,
        recipeTitle: String?? = nil,
        usersid: Int?? = nil,
        files: Files?? = nil,
        categoriesid: Int?? = nil,
        categoriesTitle: String?? = nil
        ) -> MenuRecipeData {
        return MenuRecipeData(
            menuRecipeid: menuRecipeid ?? self.menuRecipeid,
            recipeid: recipeid ?? self.recipeid,
            recipeTitle: recipeTitle ?? self.recipeTitle,
            usersid: usersid ?? self.usersid,
            files: files ?? self.files,
            categoriesid: categoriesid ?? self.categoriesid,
            categoriesTitle: categoriesTitle ?? self.categoriesTitle
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
