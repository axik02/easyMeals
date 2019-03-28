//
//  MenuContentCVCell.swift
//  EasyMeals
//
//  Created by Максим on 3/27/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class MenuContentCVCell: ContentCVCell {
    
    var dispatchGroup = DispatchGroup()
    private var recipesArray = [MenuRecipeData]()
    
    @available(*, unavailable)
    override func setDefaultPages() {
        return
    }
    
    @available(*, unavailable)
    override func getRecipe(page: Int) {
        return
    }
    
    func menuGetRecipe(withDay day:String) {
        dispatchGroup.enter()
        self.parentVCDelegate.controllerStartProcessing(withStatus: nil)
        RequestManager.menuRecipeGetByDay(day) { [weak self] (result) in
            guard let self = self else { return }
            self.parentVCDelegate.controllerStopProcessing()
            switch result {
            case .success(let data):
                if data.data!.count == 0 {
                    self.contentTableView.isHidden = true
                } else {
                    self.contentTableView.isHidden = false
                }
                self.recipesArray = data.data!
                UIView.performWithoutAnimation {
                    self.contentTableView.reloadData()
                }
            case .error(let error):
                Constants.showAlert("Error", message: error.description)
            }
            self.dispatchGroup.leave()
        }
    }
    
    @objc func shuffleBtnTap(_ sender: UIButton) {
        if sender.tag != -1 {
            let cell = contentTableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! MealTVCell
            let recipe = cell.menuRecipeData
            self.parentVCDelegate.controllerStartProcessing(withStatus: nil)
            RequestManager.menuRegenerateRecipe(recipe!.menuRecipeid!) { (result) in
                self.parentVCDelegate.controllerStopProcessing()
                switch result {
                case .success(let data):
                    self.recipesArray.remove(at: sender.tag)
                    self.recipesArray.insert(data.data!, at: sender.tag)
                    UIView.performWithoutAnimation {
                        self.contentTableView.reloadData()
                    }
                case .error(let error):
                    Constants.showAlert("Error", message: error.localizedDescription)
                }
            }
        }
    }
    
}

extension MenuContentCVCell {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contentTableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! MealTVCell
        let recipe = recipesArray[indexPath.row]
        cell.configureCell(withMenuRecipe: recipe)
        cell.shuffleButton.addTarget(self, action: #selector(shuffleBtnTap(_:)), for: .touchUpInside)
        cell.shuffleButton.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipesArray[indexPath.row]
        let recipeID = recipe.recipeid
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: RecipeDetailsVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailsVC") as! RecipeDetailsVC
        vc.recipeID = recipeID
        vc.recipeDelegate = self
        self.parentVCDelegate.getVC().navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

