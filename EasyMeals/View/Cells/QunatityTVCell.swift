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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
