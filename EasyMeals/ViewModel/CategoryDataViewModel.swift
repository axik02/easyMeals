//
//  IngredientViewModel.swift
//  EasyMeals
//
//  Created by Максим on 3/19/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class CategoryDataViewModel {
    
    private var categoryData: CategoryData!
    
    init(categoryData: CategoryData) {
        self.categoryData = categoryData
    }
    
    public var categoryLabelText: String {
        return categoryData.title ?? ""
    }
    
}
