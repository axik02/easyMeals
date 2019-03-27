//
//  Recipe.swift
//  EasyMeals
//
//  Created by Максим on 3/18/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class Recipe: Codable {
    let recipeData: RecipeData?
    
    enum CodingKeys: String, CodingKey {
        case recipeData = "data"
    }
    
    init() {
        recipeData = nil
    }
    
    init(recipeData: RecipeData?) {
        self.recipeData = recipeData
    }
}

class RecipeData: Codable {
    let recipeid: Int?
    let title: String?
    let file: FileData?
    let categories: [CategoryData]?
    let ingredients: [Ingredient]?
    let description: String?
    let usersid: Int?
    let createdAt: Int?
    
    enum CodingKeys: String, CodingKey {
        case recipeid = "recipe_id"
        case title = "title"
        case file = "files"
        case categories = "categories"
        case ingredients = "ingredients"
        case description = "description"
        case usersid = "users_id"
        case createdAt = "created_at"
    }
    
    init(recipeid: Int?, title: String?, file: FileData?, categories: [CategoryData]?, ingredients: [Ingredient]?, description: String?, usersid: Int?, createdAt: Int?) {
        self.recipeid = recipeid
        self.title = title
        self.file = file
        self.categories = categories
        self.ingredients = ingredients
        self.description = description
        self.usersid = usersid
        self.createdAt = createdAt
    }
}

class Ingredient: Codable {
    let recipeIngredientsid: Int?
    let quantity: Double?
    let unit: String?
    let title: String?
    
    enum CodingKeys: String, CodingKey {
        case recipeIngredientsid = "recipe_ingredients_id"
        case quantity = "quantity"
        case unit = "unit"
        case title = "title"
    }
    
    init(recipeIngredientsid: Int?, quantity: Double?, unit: String?, title: String?) {
        self.recipeIngredientsid = recipeIngredientsid
        self.quantity = quantity
        self.unit = unit
        self.title = title
    }
}

// MARK: Convenience initializers and mutators

extension Recipe {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Recipe.self, from: data)
        self.init(recipeData: me.recipeData)
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
        recipeData: RecipeData?? = nil
        ) -> Recipe {
        return Recipe(
            recipeData: recipeData ?? self.recipeData
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

extension RecipeData {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(RecipeData.self, from: data)
        self.init(recipeid: me.recipeid, title: me.title, file: me.file, categories: me.categories, ingredients: me.ingredients, description: me.description, usersid: me.usersid, createdAt: me.createdAt)
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
        file: FileData?? = nil,
        categories: [CategoryData]?? = nil,
        ingredients: [Ingredient]?? = nil,
        description: String?? = nil,
        usersid: Int?? = nil,
        createdAt: Int?? = nil
        ) -> RecipeData {
        return RecipeData(
            recipeid: recipeid ?? self.recipeid,
            title: title ?? self.title,
            file: file ?? self.file,
            categories: categories ?? self.categories,
            ingredients: ingredients ?? self.ingredients,
            description: description ?? self.description,
            usersid: usersid ?? self.usersid,
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

extension Ingredient {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(Ingredient.self, from: data)
        self.init(recipeIngredientsid: me.recipeIngredientsid, quantity: me.quantity, unit: me.unit, title: me.title)
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
        recipeIngredientsid: Int?? = nil,
        quantity: Double?? = nil,
        unit: String?? = nil,
        title: String?? = nil
        ) -> Ingredient {
        return Ingredient(
            recipeIngredientsid: recipeIngredientsid ?? self.recipeIngredientsid,
            quantity: quantity ?? self.quantity,
            unit: unit ?? self.unit,
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
