//
//  CategoriesViewModel.swift
//  EasyMeals
//
//  Created by Максим on 3/12/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class VarietiesViewModel {
    
    private let varieties: MealVarieties
    
    init(varieties: MealVarieties) {
        self.varieties = varieties
    }
    
    public var varietiesArray: [VarietyData] {
        return varieties.data ?? []
    }
    
}
