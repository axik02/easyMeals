//
//  APIRoutes.swift
//  EasyMeals
//
//  Created by Максим on 3/5/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

// Testing
let SERVER_URL:String = "http://api.easy-meals.yo-dev.online/api/v1.0/"

// Production
//let SERVER_URL:String = ""

enum APIRoutes: String {
    
    // MARK: - Auth
    
    case refreshTokens = "auth/tokens/refresh" // POST
    case signIn = "auth/sign-in" // POST
    case signUp = "auth/sign-up" // POST
    case passwordRecovery = "auth/password/recovery" // POST
    
    // MARK: User
    
    case userMyProfileGet = "users/profile/my" // GET
    case userSettingsEdit = "users/settings/edit" // PUT
    
    // MARK: Categories
    
    case сategoriesGet = "recipe/categories" // GET
    
    // MARK: Recipe
    
    case recipeMyGet = "recipe/my" // GET
    case recipeByCategoryIDGet = "recipe/my/by-category/" // + {Category_ID} GET
    case recipeByID = "recipe/" // + {Recipe_ID} GET to get || PUT to edit
    case recipeCreate = "recipe" // POST
    case recipeFind = "recipe/find" // GET
    case recipePDFCreate = "recipe/to-pdf/" // + {Recipe_ID} GET
    
    // MARK: Menu
    
    case menuGenerate = "recipe/menu/generate" // POST
    case menuGetByDay = "recipe/menu/" // + {day_of_week} GET
    case menuRecipeRegenerate = "recipe/menu/generate/" // + {menu_recipe_id} POST
    
    // MARK: File
    
    case fileUpload = "files" // POST
    case fileDelete = "files/" // + {files_id} DELETE
    
    // MARK: Preferences
    
    case mealsQuantityGet = "recipe/meals-quantity" // GET
    case mealsVarietyGet = "recipe/meals-variety" // GET

    
}
