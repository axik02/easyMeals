//
//  RequestManager.swift
//  EasyMeals
//
//  Created by Максим on 2/22/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation
import Alamofire

class RequestManager {
    
    private init() {}
    
    static fileprivate let tokenHeader = ["Authorization" : "Bearer " + (Constants.currentUser?.jwtToken ?? "")]
    
    // MARK: - Auth requests
    
    static public func refreshTokens(complete: @escaping UserFetchCompleted) {
        
        guard let refreshToken = Constants.keychainInstance.get(Constants.keychainKeys.keyForRefreshToken) else {
            let error = ErrorHelper.shared.error("Refresh token is nil", "Refresh token is nil")
            complete(RequestResult.error(error))
            return
        }
        
        let parameters = [
            "device_token"  : Constants.deviceToken,
            "refresh_token" : refreshToken
        ] as JSONParameters
        
        Service_API.callWebservice(apiPath: APIRoutes.refreshTokens.rawValue, method: .post, header: [:], params: parameters) { (result) in
            switch result {
            case .success(let data):
                do {
//                    let decoder = JSONDecoder()
//                    let user = try decoder.decode(User.self, from: data)
                    let user = try User(data: data)
                    guard let _ = user.data else {
                        let error = ErrorHelper.shared.error("Can not decode user data.", "Can not decode user data.")
                        complete(RequestResult.error(error as NSError))
                        return
                    }

                    saveUserInConstants(user)
                    complete(RequestResult.success(user))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error as NSError))
            }
        }
    }
    
    static public func signIn(parameters: [String:Any], complete: @escaping UserFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.signIn.rawValue, method: .post, header: [:], params: parameters) { (result) in
            switch result {
            case .success(let data):
                do {
//                    let decoder = JSONDecoder()
                    let user = try User(data: data)
                    saveUserInConstants(user)
                    complete(RequestResult.success(user))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error as NSError))
            }
        }
    }
    
    static public func signUp(parameters: [String:Any], complete: @escaping UserFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.signUp.rawValue, method: .post, header: [:], params: parameters) { (result) in
            switch result {
            case .success(let data):
                do {
                    //                    let decoder = JSONDecoder()
                    let user = try User(data: data)
                    saveUserInConstants(user)
                    complete(RequestResult.success(user))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error as NSError))
            }
        }
    }
    
    static fileprivate func saveUserInConstants(_ user: User) {
        guard let jwtToken = user.jwtToken else { return }
        guard let refreshToken = user.refreshToken else { return }
        Constants.currentUser = user
        Constants.keychainInstance.set(jwtToken, forKey: Constants.keychainKeys.keyForJWTToken)
        Constants.keychainInstance.set(refreshToken, forKey: Constants.keychainKeys.keyForRefreshToken)
    }

    // MARK: - User requests
    
    static public func getUserProfile(complete: @escaping UserFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.userMyProfileGet.rawValue, method: .get, header: tokenHeader, params: [:]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let user = try User(data: data)
                    saveUserInConstants(user)
                    complete(RequestResult.success(user))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func userEditSettings(quantityID:Int, varietyID:Int, complete: @escaping UserFetchCompleted) {
        
        let params = [
            "meals_quantity_id" : quantityID,
            "meals_variety_id": varietyID
        ] as JSONParameters
        
        Service_API.callWebservice(apiPath: APIRoutes.userSettingsEdit.rawValue, method: .put, header: tokenHeader, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let user = try User(data: data)
                    saveUserInConstants(user)
                    complete(RequestResult.success(user))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    // MARK: - Categories
    
    static public func getCategories(complete: @escaping CategoriesFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.сategoriesGet.rawValue, method: .get, header: tokenHeader, params: [:]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let categories = try decoder.decode(Categories.self, from: data)
                    complete(RequestResult.success(categories))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    // MARK: - Recipe
    
    static public func getMyRecipe(page: Int, complete: @escaping RecipesFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.recipeMyGet.rawValue, method: .get, header: tokenHeader, params: ["page": page]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(Recipes.self, from: data)
                    complete(RequestResult.success(recipes))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func getRecipeByCategoryID(_ categoryID: Int, page: Int, complete: @escaping RecipesFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.recipeByCategoryIDGet.rawValue + "\(categoryID)", method: .get, header: tokenHeader, params: ["page": page]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(Recipes.self, from: data)
                    complete(RequestResult.success(recipes))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func createRecipe(fileID: Int? = nil, title:String, categoriesIDs: String, complete: @escaping RecipeFetchCompleted) {
        
        var params = [
            "title":title,
            "categories_ids":categoriesIDs
        ] as JSONParameters
        
        if let fileID = fileID {
            params["files_id"] = fileID
        }
        
        Service_API.callWebservice(apiPath: APIRoutes.recipeCreate.rawValue, method: .post, header: tokenHeader, params: params) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let recipe = try decoder.decode(Recipe.self, from: data)
                    complete(RequestResult.success(recipe))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func editRecipe(recipeID: Int, parameters: JSONParameters, parametersEncoding: ParameterEncoding = URLEncoding.default, complete: @escaping RecipeFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.recipeByID.rawValue + "\(recipeID)", method: .put, paramsEndcoring: parametersEncoding, header: tokenHeader, params: parameters) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let recipe = try decoder.decode(Recipe.self, from: data)
                    complete(RequestResult.success(recipe))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func getRecipeByID(recipeID: Int, complete: @escaping RecipeFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.recipeByID.rawValue + "\(recipeID)", method: .get, header: tokenHeader, params: [:]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let recipe = try decoder.decode(Recipe.self, from: data)
                    complete(RequestResult.success(recipe))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func createRecipePDF(recipeID: Int, complete: @escaping RecipePDFCreateCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.recipePDFCreate.rawValue + "\(recipeID)", method: .get, header: tokenHeader, params: [:]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let recipePDF = try decoder.decode(RecipePDF.self, from: data)
                    complete(RequestResult.success(recipePDF))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func getRecipeBySearchValue(_ searchValue:String, page: Int, complete: @escaping RecipesFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.recipeFind.rawValue, method: .get, header: tokenHeader, params: ["page": page, "search_value": searchValue ]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(Recipes.self, from: data)
                    complete(RequestResult.success(recipes))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    // MARK: - Menu
    
    static public func menuGenerate(complete: @escaping MenuGenerateCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.menuGenerate.rawValue, method: .post, header: tokenHeader, params: [:]) { (result) in
            switch result {
            case .success(_):
                complete(RequestResult.success(()))
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func menuRecipeGetByDay(_ day: String, complete: @escaping MenuRecipesFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.menuGetByDay.rawValue + day, method: .get, header: tokenHeader, params: [:]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(MenuRecipes.self, from: data)
                    complete(RequestResult.success(recipes))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func menuRegenerateRecipe(_ menuRecipeID: Int, complete: @escaping MenuRecipeFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.menuRecipeRegenerate.rawValue + "\(menuRecipeID)", method: .post, header: tokenHeader, params: [:]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let recipes = try decoder.decode(MenuRecipeData.self, from: data)
                    complete(RequestResult.success(recipes))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    // MARK: - Upload/Delete File

    static public func uploadFile(image: UIImage, complete: @escaping ResultWithFile) {
        Service_API.callWebserviceMultipartMethodForSingleImage(apiPath: APIRoutes.fileUpload.rawValue, data: image, nameImageFiled: "file", fileName: "file.jpg", header: tokenHeader, params: [:], options: nil) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let file = try decoder.decode(File.self, from: data)
                    complete(RequestResult.success(file))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func deleteFile(fileID: Int, complete: @escaping ResultWithFile) {
        Service_API.callWebservice(apiPath: APIRoutes.fileDelete.rawValue + "\(fileID)", method: .delete, header: tokenHeader, params: [:]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let file = try decoder.decode(File.self, from: data)
                    complete(RequestResult.success(file))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    // MARK: Preferences
    
    static public func getMealQuantities(complete: @escaping QuantitiesFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.mealsQuantityGet.rawValue, method: .get, header: tokenHeader, params: [:]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let quantities = try decoder.decode(MealQuantities.self, from: data)
                    complete(RequestResult.success(quantities))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
    static public func getMealVarieties(complete: @escaping VarietiesFetchCompleted) {
        Service_API.callWebservice(apiPath: APIRoutes.mealsVarietyGet.rawValue, method: .get, header: tokenHeader, params: [:]) { (result) in
            switch result {
            case .success(let data):
                do {
                    let decoder = JSONDecoder()
                    let varieties = try decoder.decode(MealVarieties.self, from: data)
                    complete(RequestResult.success(varieties))
                } catch {
                    complete(RequestResult.error(error as NSError))
                }
            case .error(let error):
                complete(RequestResult.error(error))
            }
        }
    }
    
}
