//
//  RecipeSearchVC.swift
//  EasyMeals
//
//  Created by Максим on 3/21/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class RecipeSearchVC: ParentVC {

    // MARK: - IBOutlets
    
    @IBOutlet weak var contentTableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var mealsLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - IBActions
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        onParentBack()
    }
    
    // MARK: - Variables
    
    private var recipesArray = [RecipesData]()
    
    private var currentPage = 1
    private var countOfPages = 1
    private var totalItems = 0
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        if recipesArray.count == 0 {
            bgView.isHidden = true
        } else {
            bgView.isHidden = false
        }
        
        let logoLabelBounds = mealsLabel.bounds
        UIView.animate(withDuration: 0.3) {
            self.mealsLabel.bounds = CGRect(x: logoLabelBounds.maxX - 2, y: logoLabelBounds.maxY - 2, width: logoLabelBounds.width + 4, height: logoLabelBounds.height + 4)
        }
    }

    private func searchRecipe(_ searchValue: String, page: Int = 1) {
        self.startProcessing()
        RequestManager.getRecipeBySearchValue(searchValue, page: page) { [weak self] (result) in
            guard let self = self else { return }
            self.stopProcessing()
            switch result {
            case .success(let data):
                self.currentPage = data.currentPage!
                self.countOfPages = data.countOfPages!
                self.totalItems = data.totalItems!
                self.recipesArray.append(data.data!)
                if self.recipesArray.count == 0 {
                    self.bgView.isHidden = true
                } else {
                    self.bgView.isHidden = false
                }
                self.contentTableView.reloadData()
            case .error(let error):
                Constants.showAlert("Error", message: error.description)
            }
        }
    }
    
    fileprivate func setDefaultPages() {
        currentPage = 1
        countOfPages = 1
        totalItems = 0
        recipesArray.removeAll()
        UIView.performWithoutAnimation {
            self.contentTableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoRecipeDetailsVC" {
            if let recipeDetailsVC = segue.destination as? RecipeDetailsVC {
                if let recipeID = sender as? Int {
                    recipeDetailsVC.recipeID = recipeID
                }
            }
        }
    }

}

// MARK: - UITextFieldDelegate

extension RecipeSearchVC {
    
    override func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.setDefaultPages()
        self.searchRecipe(textField.text!)        
        textField.resignFirstResponder()
        return super.textFieldShouldReturn(textField)
    }
    
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension RecipeSearchVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealTVCell
        if indexPath.row == recipesArray.count-1 {
            if totalItems > recipesArray.count {
                self.searchRecipe(searchTextField.text!, page: currentPage + 1)
            }
        }
        let recipe = recipesArray[indexPath.row]
        cell.configureCell(withRecipe: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipesArray[indexPath.row]
        let recipeID = recipe.recipeid!
        self.performSegue(withIdentifier: "GotoRecipeDetailsVC", sender: recipeID)
    }
    
}
