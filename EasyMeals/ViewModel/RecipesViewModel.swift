//
//  RecipeViewModel.swift
//  EasyMeals
//
//  Created by Максим on 3/12/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class RecipesViewModel {
    
    private var recipes: Recipes?
    
    init () {}
    
    init(recipes: Recipes) {
        self.recipes = recipes
    }
    
    public var recipesArray: [RecipesData] {
        return recipes?.data ?? []
    }
    
}
