//
//  AddIngredientsVC.swift
//  EasyMeals
//
//  Created by Максим on 3/16/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit
import Alamofire

class AddIngredientsVC: ParentVC {

    // MARK: - IBOutlets
    
    @IBOutlet weak var ingredientTableView: UITableView!
    
    // MARK: - IBActions

    @IBAction func backBtnTap(_ button: UIButton) {
        onParentBack()
    }

    @IBAction func nextBtnTap(_ button: UIButton) {
        editIngredientsAndPerformSegue()
    }
    
    @IBAction func addIngredientButtonTap(_ sender: DesignableButton) {
        self.performSegue(withIdentifier: "GotoAddIngredientPopUpVC", sender: nil)
    }
    
    // MARK: - Variables
    
    var recipe:Recipe!
    var ingredients = [Ingredient]()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredients = (recipe.recipeData?.ingredients)!
    }
    
    // MARK: - Private functions
   
    private func editIngredientsAndPerformSegue() {
        
        if ingredients.count > 0 {
            var ingredientsDictsArray = [JSONParameters]()
            var ingredientDict = [:] as JSONParameters
            
            for ingredient in ingredients {
                ingredientDict["quantity"] = ingredient.quantity
                ingredientDict["unit"] = ingredient.unit
                ingredientDict["title"] = ingredient.title
                ingredientDict["recipe_ingredients_id"] = ingredient.recipeIngredientsid
                
                ingredientsDictsArray.append(ingredientDict)
            }
            
            let params = ["ingredients" : ingredientsDictsArray] as JSONParameters
            
            self.startProcessing()
            RequestManager.editRecipe(recipeID: recipe.recipeData!.recipeid!, parameters: params, parametersEncoding: JSONEncoding.default) { [weak self] (result) in
                guard let self = self else { return }
                self.stopProcessing()
                switch result {
                case .success(let data):
                    self.recipe = data
                    self.performSegue(withIdentifier: "GotoPreparationDetailsVC", sender: data)
                case .error(let error):
                    Constants.showAlert("Error", message: error.localizedDescription)
                }
            }
        } else {
            self.performSegue(withIdentifier: "GotoPreparationDetailsVC", sender: recipe)
        }
        
    }
    
    fileprivate func showDeleteAlert(index: Int) {
        let alert = UIAlertController(title: nil, message: "Remove this ingredient?", preferredStyle: .alert)
        alert.addAction(image: nil, title: "Yes", color: nil, style: .default, isEnabled: true) { (_) in
            self.ingredients.remove(at: index)
            UIView.performWithoutAnimation {
                self.ingredientTableView.reloadData()
            }
        }
        alert.addAction(image: nil, title: "Cancel", color: nil, style: .cancel, isEnabled: true) { (_) in
            alert.dismiss(animated: true, completion: nil)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoAddIngredientPopUpVC" {
            if let vc: AddIngredientPopUpVC = segue.destination as? AddIngredientPopUpVC {
                vc.ingredientPopUpDelegate = self
            }
        }
        
        if segue.identifier == "GotoPreparationDetailsVC" {
            if let vc:AddPreparationDetailsVC = segue.destination as? AddPreparationDetailsVC {
                if let recipe = sender as? Recipe {
                    vc.recipe = recipe
                }
            }
        }
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension AddIngredientsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ingredientTableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! IngredientTVCell
        let ingredient = ingredients[indexPath.row]
        cell.configureCell(withIngredient: ingredient)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDeleteAlert(index: indexPath.row)
    }
    
}

// MARK: - IngredientPopUpDelegate

extension AddIngredientsVC: IngredientPopUpDelegate {
    func ingredientPopUp(DidAddedIngredient ingredient: Ingredient) {
        self.ingredients.append(ingredient)
        UIView.performWithoutAnimation {
            self.ingredientTableView.reloadData()
        }
    }
}
