//
//  MealTVCell.swift
//  EasyMeals
//
//  Created by Максим on 10.07.2018.
//  Copyright © 2018 Yobibyte. All rights reserved.
//

import UIKit

class MealTVCell: UITableViewCell {
    
    @IBOutlet weak var mealImageView: UIImageView!
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var shuffleButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(withRecipe recipe:RecipesData) {
        self.mealNameLabel.text = recipe.title
        if let files = recipe.files {
            if let filename = files.filename {
                if let url = URL(string: filename) {
                    self.mealImageView.af_setImage(withURL: url)
                }
            }
        }
    }

    
    func configureCell(withMenuRecipe recipe:MenuRecipeData) {
        self.mealNameLabel.text = recipe.recipeTitle
        self.categoryLabel.text = recipe.categoriesTitle
        if let files = recipe.files {
            if let filename = files.filename {
                if let url = URL(string: filename) {
                    self.mealImageView.af_setImage(withURL: url)
                }
            }
        }
    }
    
}
