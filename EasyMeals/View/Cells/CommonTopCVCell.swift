//
//  CategoryCVCell.swift
//  EasyMeals
//
//  Created by Максим on 09.07.2018.
//  Copyright © 2018 Yobibyte. All rights reserved.
//

import UIKit

class CommonTopCVCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(withCategory category: CategoryData) {
        let categoryDataViewModel = CategoryDataViewModel(categoryData: category)
        self.nameLabel.text = categoryDataViewModel.categoryLabelText
    }
    
    func configureCell(withDay day: String) {
        self.nameLabel.text = day.capitalized
    }
    
}
