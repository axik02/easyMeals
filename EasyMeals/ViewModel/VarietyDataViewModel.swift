//
//  VarietyDataViewModel.swift
//  EasyMeals
//
//  Created by Максим on 3/26/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import Foundation

class VarietyDataViewModel {
    
    private var varietyData: VarietyData!
    
    init(varietyData: VarietyData) {
        self.varietyData = varietyData
    }
    
    public var varietyLabelText: String {
        return varietyData.title ?? ""
    }
    
    public var id:Int {
        return varietyData.mealsVarietyid ?? 0
    }
    
}
