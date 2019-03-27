//
//  CategoriesViewModel.swift
//  EasyMeals
//
//  Created by Максим on 3/12/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class QuantitiesViewModel {
    
    private let quantities: MealQuantities
    
    init(quantities: MealQuantities) {
        self.quantities = quantities
    }
    
    public var quantitiesArray: [QuantityData] {
        return quantities.data ?? []
    }
    
}
