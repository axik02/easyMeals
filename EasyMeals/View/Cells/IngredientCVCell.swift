//
//  CategoryCVCell.swift
//  EasyMeals
//
//  Created by Максим on 09.07.2018.
//  Copyright © 2018 Yobibyte. All rights reserved.
//

import UIKit
import MarqueeLabel

class IngredientCVCell: UICollectionViewCell {
    
    @IBOutlet weak var ingredientLabel: MarqueeLabel!
    
    func configureCell(withIngredient ingredient: Ingredient) {
        let ingredientViewModel = IngredientViewModel(ingredient: ingredient)
        self.ingredientLabel.text = ingredientViewModel.ingredientLabelText

        // Continuous, with tap to pause
        self.ingredientLabel.type = .continuous
        self.ingredientLabel.speed = .duration(10)
        self.ingredientLabel.fadeLength = 10.0
        self.ingredientLabel.trailingBuffer = 30.0
        
        self.ingredientLabel.isUserInteractionEnabled = true // Don't forget this, otherwise the gesture recognizer will fail (UILabel has this as NO by default)
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(pauseTap))
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        self.ingredientLabel.addGestureRecognizer(tapRecognizer)

    }
    
    @objc func pauseTap(_ recognizer: UIGestureRecognizer) {
        let continuousLabel2 = recognizer.view as! MarqueeLabel
        if recognizer.state == .ended {
            continuousLabel2.isPaused ? continuousLabel2.unpauseLabel() : continuousLabel2.pauseLabel()
        }
    }
}
