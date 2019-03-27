//
//  AddIngredientPopUpVC.swift
//  EasyMeals
//
//  Created by Максим on 3/22/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

protocol IngredientPopUpDelegate {
    func ingredientPopUp(DidAddedIngredient ingredient: Ingredient)
}

class AddIngredientPopUpVC: ParentVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var nameTextFieldBGView: DesignableView!
    @IBOutlet fileprivate weak var nameTextField: DisabledPasteTextField!
    
    @IBOutlet weak var quantityTextFieldBGView: DesignableView!
    @IBOutlet fileprivate weak var quantityTextField: DisabledPasteTextField!
    
    @IBOutlet weak var unitTextFieldBGView: DesignableView!
    @IBOutlet fileprivate weak var unitTextField: DisabledPasteTextField!

    @IBOutlet weak var backgroundView: DesignableView!
    
    // MARK: - Variables
    
    let unitPickerView = UIPickerView()
    let unitArray = ["kg", "g", "ml", "l", "piece"]
    var ingredientPopUpDelegate: IngredientPopUpDelegate!
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTap(_ sender: UIButton) {
        animateCustomDissmiss()
    }
    
    @IBAction func addButtonTap(_ sender: UIButton) {
        
        if !validateTextFields() {
            toggleBackgroundView()
            return
        }
        ingredientPopUpDelegate.ingredientPopUp(DidAddedIngredient: createIngredient())
        animateCustomDissmiss()
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        quantityTextField.keyboardType = .decimalPad
        unitTextField.inputView = unitPickerView
        unitPickerView.delegate = self
    }
    
    fileprivate func createIngredient() -> Ingredient {
        let quantity = Double(self.quantityTextField.text!) ?? 0.0
        let unit = self.unitTextField.text!
        let title = self.nameTextField.text!
        
        let ingredient = Ingredient(recipeIngredientsid: nil, quantity: quantity, unit: unit, title: title)
        return ingredient
    }
    
    fileprivate func validateTextFields() -> Bool {
        var validation = true
        let textFieldArray = [nameTextField, quantityTextField, unitTextField]
        
        textFieldArray.forEach { (textField) in
            if textField!.text!.isEmpty {
                textField?.superview?.layer.borderWidth = 1
                textField?.superview?.layer.borderColor = UIColor.red.cgColor
                validation = false
            }
        }
        
        return validation
    }
    
    
    fileprivate func toggleBackgroundView() {
        
        UIView.animate(withDuration: 0.1,
                       delay: 0.0,
                       options: [.curveLinear],
                       animations: {
            self.backgroundView.transform = CGAffineTransform(translationX: 5, y: 0)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.1,
                           delay: 0.0,
                           options: [.curveLinear],
                           animations: {
                self.backgroundView.transform = CGAffineTransform(translationX: -5, y: 0)
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

extension AddIngredientPopUpVC {
    override func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.superview?.layer.borderWidth = 0
        super.textFieldDidBeginEditing(textField)
    }
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return super.textFieldShouldReturn(textField)
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource

extension AddIngredientPopUpVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return unitArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.unitTextField.text = unitArray[row]
    }
}

fileprivate class DisabledPasteTextField: UITextField {
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return action == #selector(UIResponderStandardEditActions.cut) || action == #selector(UIResponderStandardEditActions.copy)
    }
}
