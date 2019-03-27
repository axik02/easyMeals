//
//  HeaderView.swift
//  EasyMeals
//
//  Created by Максим on 3/25/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit


class SectionHeaderView : UIView {
    @IBOutlet var contentView:HeaderView?
    // other outlets
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed("SectionHeaderView", owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
}

class HeaderView: UIView {

    @IBOutlet private var sectionImageView: UIImageView!
    @IBOutlet private var arrowImageView: UIImageView!
    @IBOutlet private var sectionNameLabel: UILabel!
    @IBOutlet private var titleLabel: UILabel!
        
    func setTitleLabel(_ text: String) {
        titleLabel.text = text
    }
    
    func setSectionLabel(_ text: String) {
        sectionNameLabel.text = text
    }
    
    func setSectionImage(_ image: UIImage) {
        sectionImageView.image = image
    }
    
    func rotateArrow(collapsed:Bool) {
        arrowImageView.transform = .identity
        arrowImageView.rotate(collapsed ? 0.0 : -.pi, duration: 0.0)
    }
    
    func rotateArrowWithoutAnimation(collapsed:Bool) {
        arrowImageView.transform = CGAffineTransform(rotationAngle: collapsed ? 0.0 : -.pi)
    }
    
}


