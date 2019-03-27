//
//  AddIngredientPopUpVC.swift
//  EasyMeals
//
//  Created by Максим on 3/22/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class URLPopUpVC: ParentVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var urlTextFieldBGView: DesignableView!
    @IBOutlet fileprivate weak var urlTextField: CopyOnlyTextField!
    
    @IBOutlet weak var backgroundView: DesignableView!
    
    var urlString: String!
    
    // MARK: - IBActions
    
    @IBAction func closeButtonTap(_ sender: UIButton) {
        animateCustomDissmiss()
    }
    
    @IBAction func copyButtonTap(_ sender: UIButton) {
        UIPasteboard.general.string = urlString
        toggleBackgroundView()
    }
    
    @IBAction func urlTextFieldChanged(_ sender: UITextField) {
        sender.text = urlString
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        urlTextField.text = urlString
    }
    
    fileprivate func toggleBackgroundView() {
        
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.curveLinear],
                       animations: {
                        self.backgroundView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.1,
                           delay: 0.0,
                           options: [.curveLinear],
                           animations: {
                            self.backgroundView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }, completion: { (_) in
                UIView.animate(withDuration: 0.1,
                               delay: 0.0,
                               options: [.curveLinear],
                               animations: {
                                self.backgroundView.transform = .identity
                })
            })
        })
    }
    
    fileprivate func animateCustomDissmiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.backgroundView.alpha = 0.0
        }) { (_) in
            self.onParentDismiss(animated: false)
        }
    }
    
}

// MARK: - UITextField Delegate

extension URLPopUpVC {
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return super.textFieldShouldReturn(textField)
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == urlTextField {
            return false; //do not show keyboard nor cursor
        }
        return true
    }
    
}

fileprivate class CopyOnlyTextField: UITextField {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.copy)
    }
}
