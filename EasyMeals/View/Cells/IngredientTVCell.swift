//
//  IngredientTVCell.swift
//  EasyMeals
//
//  Created by Максим on 3/22/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class IngredientTVCell: UITableViewCell {

    @IBOutlet weak var ingredientNameLabel: UILabel!
    
    func configureCell(withIngredient ingredient: Ingredient) {
        let ingredientViewModel = IngredientViewModel(ingredient: ingredient)
        self.ingredientNameLabel.text = ingredientViewModel.ingredientLabelText
    }

}
