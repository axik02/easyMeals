//
//  QunatityTVCell.swift
//  EasyMeals
//
//  Created by Максим on 3/25/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class QuantityTVCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectionImageView: UIImageView!

    func configureCell(withQuantity quantity: QuantityData, selectedQuantityID: Int) {
        let quantityDataViewModel = QuantityDataViewModel(quantityData: quantity)
        self.nameLabel.text = quantityDataViewModel.quantityLabelText
        
        if selectedQuantityID == quantityDataViewModel.id {
            selectionImageView.image = #imageLiteral(resourceName: "ic_category_selected")
        } else {
            selectionImageView.image = #imageLiteral(resourceName: "ic_category_unselected")
        }
    }

}
