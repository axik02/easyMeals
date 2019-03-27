//
//  File.swift
//  EasyMeals
//
//  Created by Максим on 2/20/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class CategoryPickCVCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(data:[String:Any]) {
        let isSelected = data["is_selected"] as? Bool ?? false
        selectedImageView.image = isSelected == true ? #imageLiteral(resourceName: "ic_category_selected") : #imageLiteral(resourceName: "ic_category_unselected")
        nameLabel.text = data["name"] as? String ?? ""
    }
    
}
