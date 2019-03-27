//
//  CollapsibleTableViewHeader.swift
//  CollapsibleTableSectionViewController
//
//  Created by Yong Su on 7/20/17.
//  Copyright © 2017 jeantimex. All rights reserved.
//

import UIKit

protocol CollapsibleTableViewHeaderDelegate: class {
    func toggleSection(_ section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView {

    weak var delegate: CollapsibleTableViewHeaderDelegate?
    
    let sectionHeaderView = SectionHeaderView()

    var section: Int? {
        didSet {
            switch section {
            case 0:
                sectionHeaderView.contentView?.setSectionImage(#imageLiteral(resourceName: "img_quantity_section"))
                sectionHeaderView.contentView?.setSectionLabel("Meals Quantity")
            case 1:
                sectionHeaderView.contentView?.setSectionImage(#imageLiteral(resourceName: "img_variety_section"))
                sectionHeaderView.contentView?.setSectionLabel("Meals Variety")
            default:
                break
            }
        }
    }
    
    var titleText: String? {
        didSet {
            sectionHeaderView.contentView?.setTitleLabel(titleText ?? "")
        }
    }
    
    override public init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        // Content View
        contentView.backgroundColor = .white
        contentView.addSubview(sectionHeaderView)
        let marginGuide = contentView.layoutMarginsGuide
        
        sectionHeaderView.translatesAutoresizingMaskIntoConstraints = false
        sectionHeaderView.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        sectionHeaderView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        sectionHeaderView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        sectionHeaderView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        // Call tapHeader when tapping on this header
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Trigger toggle section when tapping on the header
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        if let section = cell.section {
            _ = delegate?.toggleSection(section)
        }
    }
    
    func setCollapsed(_ collapsed: Bool, shouldRotateArrow: Bool = true) {
        // Animate the arrow rotation
        if shouldRotateArrow {
            sectionHeaderView.contentView?.rotateArrowWithoutAnimation(collapsed: collapsed)
//            sectionHeaderView.contentView?.rotateArrow(collapsed: collapsed)
        }
    }
    
}

extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.3) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
}


