//
//  RecipeViewModel.swift
//  EasyMeals
//
//  Created by Максим on 3/19/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class RecipeViewModel {
    
    private var recipe: Recipe!
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    public var recipeTitle: String {
        return recipe.recipeData?.title ?? ""
    }
    
    public var recipeImageUrl: URL? {
        let stringUrl = recipe.recipeData?.file?.filename ?? ""
        if !stringUrl.isEmpty {
            return URL(string: stringUrl)
        }
        return nil
    }
    
    public var recipeFileID: Int? {
        return recipe.recipeData?.file?.filesid
    }
    
    public var recipeImageView: UIImageView {
        let stringUrl = recipe.recipeData?.file?.filename ?? ""
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "img_splash")
        if !stringUrl.isEmpty {
            if let url = URL(string: stringUrl) {
                imageView.af_setImage(withURL: url)
                return imageView
            } else {
                print("Wrong Image URL")
                return imageView
            }
        } else {
            print("Wrong Image URL or some variable is nil")
            return imageView
        }
    }
    
    public var recipeDescription: String {
        return recipe.recipeData?.description ?? ""
    }
    
    public var categories: [CategoryData] {
        return recipe.recipeData?.categories ?? []
    }
    
    public var ingredients: [Ingredient] {
        return recipe.recipeData?.ingredients ?? []
    }
    
    public var ownerID: Int {
        return recipe.recipeData?.usersid ?? -1
    }
    
}
