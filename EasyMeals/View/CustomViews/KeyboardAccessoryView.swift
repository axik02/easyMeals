//
//  KeyboardAccessoryView.swift
//  EasyMeals
//
//  Created by Максим on 3/22/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class KeyboardAccessoryView: UIView {

    @IBOutlet weak var centralLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    func setCentralLabelText(_ text: String) {
        self.centralLabel.text = text
    }
    
    func setLeftButtonTitle(_ title: String) {
        self.leftButton.setTitle(title, for: .normal)
    }
    
}
