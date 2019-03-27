//
//  VarietyDataViewModel.swift
//  EasyMeals
//
//  Created by Максим on 3/26/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class QuantityDataViewModel {
    
    private var quantityData: QuantityData!
    
    init(quantityData: QuantityData) {
        self.quantityData = quantityData
    }
    
    public var quantityLabelText: String {
        return quantityData.title ?? ""
    }
    
    public var id: Int {
        return quantityData.mealsQuantityid ?? 0
    }
    
}
