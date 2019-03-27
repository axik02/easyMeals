//
//  QunatityTVCell.swift
//  EasyMeals
//
//  Created by Максим on 3/25/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class VarietyTVCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!

    func configureCell(withVariety variety: VarietyData, selectedVarieryID: Int) {
        let varietyDataViewModel = VarietyDataViewModel(varietyData: variety)
        self.nameLabel.text = varietyDataViewModel.varietyLabelText
        
        if selectedVarieryID == varietyDataViewModel.id {
            selectionImageView.image = #imageLiteral(resourceName: "ic_category_selected")
        } else {
            selectionImageView.image = #imageLiteral(resourceName: "ic_category_unselected")
        }
    }
    
}
