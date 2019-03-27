//
//  MenuContentCVCell.swift
//  EasyMeals
//
//  Created by Максим on 3/27/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class MenuContentCVCell: ContentCVCell {
    
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
        }
    }
    
    @objc func shuffleBtnTap(_ sender: UIButton) {
        if sender.tag != -1 {
            self.parentVCDelegate.controllerStartProcessing(withStatus: nil)
            RequestManager.menuRegenerateRecipe(sender.tag) { (result) in
                self.parentVCDelegate.controllerStopProcessing()
                switch result {
                case .success(let data):
                    self.recipesArray.remove(at: sender.tag)
                    self.recipesArray.insert(data, at: sender.tag)
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
        cell.shuffleButton.tag = recipe.menuRecipeid ?? -1
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = recipesArray[indexPath.row]
        let recipeID = recipe.recipeid
        self.parentVCDelegate.controllerPerformSegue(withIdentifier: "GotoRecipeDetailsVC", item: recipeID)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
