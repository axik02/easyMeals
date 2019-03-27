//
//  IngredientViewModel.swift
//  EasyMeals
//
//  Created by Максим on 3/19/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class IngredientViewModel {
    
    private var ingredient: Ingredient!
    
    init(ingredient: Ingredient) {
        self.ingredient = ingredient
    }
    
    public var ingredientLabelText: String {
        let ingredientTitleString = ingredient.title ?? ""
        let quantityString = String(ingredient.quantity ?? 0.0)
        let ingredientUnitString = ingredient.unit ?? ""
        let fullText = ingredientTitleString + " " + quantityString + " " + ingredientUnitString
        return fullText
    }
    
}
