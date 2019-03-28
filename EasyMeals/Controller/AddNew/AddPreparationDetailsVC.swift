//
//  AddPreparationDetailsVC.swift
//  EasyMeals
//
//  Created by Максим on 3/16/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class AddPreparationDetailsVC: ParentVC {
    
    // MARK: - Outlets

    @IBOutlet weak var detailsTextView: UITextView!
    
    // MARK: - Variables
    
    var recipe:Recipe!

    // MARK: - IBActions

    @IBAction func backBtnTap(_ button: UIButton) {
        onParentBack()
    }

    @IBAction func saveBtnTap(_ button: UIButton) {
        
        if detailsTextView.text! != "Start typing" {
            let params = [
                "description" : detailsTextView.text!
                ] as JSONParameters
            
            self.startProcessing()
            RequestManager.editRecipe(recipeID: recipe.recipeData!.recipeid!, parameters: params) { (result) in
                self.stopProcessing()
                switch result {
                case .success(_):
                    self.goBackToPreviousVC()
                case .error(let error):
                    Constants.showAlert("Error", message: error.description)
                }
            }
        } else {
            let params = [
                "description" : ""
                ] as JSONParameters
            
            self.startProcessing()
            RequestManager.editRecipe(recipeID: recipe.recipeData!.recipeid!, parameters: params) { (result) in
                self.stopProcessing()
                switch result {
                case .success(_):
                    self.goBackToPreviousVC()
                case .error(let error):
                    Constants.showAlert("Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTextView()
    }
    
    // MARK: - Private functions
    
    private func setUpTextView() {
        detailsTextView.keyboardAppearance = .dark
        let recipeDescription = recipe.recipeData?.description ?? "Start typing"
        detailsTextView.text = recipeDescription == "" ? "Start typing" : recipeDescription
        if detailsTextView.text == "Start typing" {
            detailsTextView.textColor = #colorLiteral(red: 0.7921568627, green: 0.7921568627, blue: 0.7921568627, alpha: 1)
        } else {
            detailsTextView.textColor = #colorLiteral(red: 0.2177612185, green: 0.2177672982, blue: 0.2177640498, alpha: 1)
        }
        
    }
    
    private func goBackToPreviousVC() {
        let viewControllers = self.navigationController!.viewControllers
        self.navigationController?.viewControllers.remove(at: viewControllers.count - 2)
        self.navigationController?.viewControllers.remove(at: viewControllers.count - 3)
        
        self.onParentBack()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


// MARK: - UITextViewDelegate

extension AddPreparationDetailsVC {
    
    override func textViewDidBeginEditing(_ textView: UITextView) {
        super.textViewDidBeginEditing(textView)
        if textView.text == "Start typing" {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.2177612185, green: 0.2177672982, blue: 0.2177640498, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Start typing"
            textView.textColor = #colorLiteral(red: 0.7921568627, green: 0.7921568627, blue: 0.7921568627, alpha: 1)
        }
    }
    
}
