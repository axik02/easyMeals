//
//  ContentCVCell.swift
//  EasyMeals
//
//  Created by Максим on 10.07.2018.
//  Copyright © 2018 Yobibyte. All rights reserved.
//

import UIKit

class ContentCVCell: UICollectionViewCell {

    @IBOutlet weak var contentTableView: UITableView!
    
    var parentVCDelegate: ParentVCDelegate!
    private var recipesArray = [RecipesData]()
    
    var categoryID: Int!
    
    private var currentPage = 1
    private var countOfPages = 1
    private var totalItems = 0
    
    func getRecipe(page: Int) {
        
        if page == 1 {
            recipesArray.removeAll()
        }

        if categoryID == nil {
            getMyRecipes(page: page)
        } else {
            getRecipeByCategory(page: page)
        }
        
    }
    
    func setDefaultPages() {
        currentPage = 1
        countOfPages = 1
        totalItems = 0
        recipesArray.removeAll()
        UIView.performWithoutAnimation {
            self.contentTableView.reloadData()
        }
    }
    
    private func getMyRecipes(page: Int) {
        self.parentVCDelegate.controllerStartProcessing(withStatus: nil)
        RequestManager.getMyRecipe(page: page) { [weak self] (result) in
            guard let self = self else { return }
            self.parentVCDelegate.controllerStopProcessing()
            switch result {
            case .success(let data):
                self.currentPage = data.currentPage!
                self.countOfPages = data.countOfPages!
                self.totalItems = data.totalItems!
                self.recipesArray.append(data.data!)
                self.contentTableView.reloadData()
            case .error(let error):
                Constants.showAlert("Error", message: error.description)
            }
        }
    }
    
    private func getRecipeByCategory(page: Int) {
        self.parentVCDelegate.controllerStartProcessing(withStatus: nil)
        RequestManager.getRecipeByCategoryID(categoryID, page: page) { [weak self] (result) in
            guard let self = self else { return }
            self.parentVCDelegate.controllerStopProcessing()
            switch result {
            case .success(let data):
                self.currentPage = data.currentPage!
                self.countOfPages = data.countOfPages!
                self.totalItems = data.totalItems!
                self.recipesArray.append(data.data!)
                self.contentTableView.reloadData()
            case .error(let error):
                Constants.showAlert("Error", message: error.description)
            }
        }
    }
    
}


extension ContentCVCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealTVCell
        
        if indexPath.row == recipesArray.count-1 {
            if totalItems > recipesArray.count {
                self.getRecipe(page: currentPage + 1)
            }
        }
        let recipe = recipesArray[indexPath.row]
        cell.configureCell(withRecipe: recipe)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipesArray[indexPath.row]
        let recipeID = recipe.recipeid
        self.parentVCDelegate.controllerPerformSegue(withIdentifier: "GotoRecipeDetailsVC", item: recipeID)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
