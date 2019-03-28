//
//  AddNewRecipeVC.swift
//  EasyMeals
//
//  Created by Максим on 09.07.2018.
//  Copyright © 2018 Yobibyte. All rights reserved.
//

import UIKit

class AddNewRecipeVC: ParentVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var navigationTitleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var recipePhotoImageView: UIImageView!
    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var addAndProceedButton: UIButton!

    // MARK: - IBActions

    @IBAction func backBtnTap(_ sender: UIButton) {
        onParentBack()
    }
    
    @IBAction func addPhotoBtnTap(_ sender: UIButton) {
        PhotoHandler.shared.showAttachmentActionSheet(vc: self)
        PhotoHandler.shared.imagePickedBlock = { (image) in
            self.recipePhotoImageView.image = image
            self.choosenImage = image
//            self.imgData = image.jpegData(compressionQuality: 1.0)!
            self.isImageChoosen = true
            self.addPhotoLabel.text = "CHANGE PHOTO"
        }
    }
    
    @IBAction func proceedBtnTap(_ sender: DesignableButton) {
        if recipeID == nil {
            createNewRecipe()
        } else {
            editRecipe()
        }
    }
    
    // MARK: - Variables
    
    private var isCategoryChoosen = false
    private var isImageChoosen = false
    private var choosenImage = UIImage()
    
    private var categoryArray = Constants.categoriesViewModel!.categoriesArray
    private var isRecipeAdded = false
    
    var recipeID: Int?
    private var currentFileID: Int?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCategoriesUnselected()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if recipeID != nil {
            self.addAndProceedButton.setTitle("Edit and Proceed", for: .normal)
            self.navigationTitleLabel.text = "Edit Recipe"
            getRecipe()
        }
    }
    
    // MARK: - Private functions
    
    private func getRecipe() {
        
        self.startProcessing()
        RequestManager.getRecipeByID(recipeID: recipeID!) { [weak self] (result) in
            guard let self = self else { return }
            self.stopProcessing()
            switch result {
            case .success(let data):
                let recipeViewModel = RecipeViewModel(recipe: data)
                self.titleTextField.text = recipeViewModel.recipeTitle
                if recipeViewModel.recipeImageUrl != nil {
                    self.recipePhotoImageView.image = recipeViewModel.recipeImageView.image
                    if let image = self.recipePhotoImageView.image {
                        self.isImageChoosen = true
                        self.choosenImage = image
                        self.addPhotoLabel.text = "CHANGE PHOTO"
                    } else {
                        self.isImageChoosen = false
                        self.choosenImage = UIImage()
                        self.addPhotoLabel.text = "ADD PHOTO"
                    }
                }
                if let recipeFileID = recipeViewModel.recipeFileID {
                    self.currentFileID = recipeFileID
                }
                let categories = recipeViewModel.categories
                for category in self.categoryArray {
                    for cat in categories {
                        if cat.categoryID == category.categoryID {
                            category.isSelected = true
                            self.isCategoryChoosen = true
                        } else {
                            self.isCategoryChoosen = false
                        }
                    }
                }
                self.categoryCollectionView.reloadData()
            case .error(let error):
                Constants.showAlert("Error", message: error.description)
            }
        }
        
    }
    
    private func createNewRecipe() {

        if !validateRecipeCategory() {
            return
        }
        
        let selectedCategoriesIDs = getSelectedCategories()
        
        if isImageChoosen {
            var fileID = 0
            self.startProcessing(withStatus: "Uploading image...")
            RequestManager.uploadFile(image: choosenImage) { (result) in
                self.stopProcessing()
                switch result {
                case .success(let file):
                    fileID = file.fileData!.filesid!
                    self.createNewRecipe(fileID: fileID, categoriesIDs: selectedCategoriesIDs)
                case .error(let error):
                    Constants.showAlert("Error", message: error.description)
                    return
                }
            }
        } else {
            self.createNewRecipe(fileID: nil, categoriesIDs: selectedCategoriesIDs)
        }
    }
    
    private func editRecipe() {
        if !validateRecipeCategory() {
            return
        }
        
        let selectedCategoriesIDs = getSelectedCategories()

        var parameters = [
            "title" : self.titleTextField.text!,
            "categories_ids" : selectedCategoriesIDs
            ] as JSONParameters

        if isImageChoosen {
            if let currentFileID = self.currentFileID {
                self.editCurrentRecipe(fileID: currentFileID, parameters: &parameters)
            } else {
                var fileID = 0
                self.startProcessing(withStatus: "Uploading image...")
                RequestManager.uploadFile(image: choosenImage) { (result) in
                    self.stopProcessing()
                    switch result {
                    case .success(let file):
                        fileID = file.fileData!.filesid!
                        self.editCurrentRecipe(fileID: fileID, parameters: &parameters)
                    case .error(let error):
                        Constants.showAlert("Error", message: error.description)
                        return
                    }
                }
            }
        } else {
            editCurrentRecipe(fileID: nil, parameters: &parameters)
        }
        
    }
    
    
    fileprivate func createNewRecipe(fileID: Int?, categoriesIDs: String) {
        self.startProcessing(withStatus: "Creating new recipe...")
        RequestManager.createRecipe(fileID: fileID, title: self.titleTextField.text!, categoriesIDs: categoriesIDs, complete: { (result) in
            self.stopProcessing()
            switch result {
            case .success(let data):
                self.recipeID = data.recipeData?.recipeid
                self.performSegue(withIdentifier: "GotoIngredientsSegue", sender: data)
            case .error(let error):
                Constants.showAlert("Error", message: error.description)
                return
            }
        })
    }
    
    fileprivate func editCurrentRecipe(fileID: Int?, parameters: inout JSONParameters) {
        
        if let fileID = fileID {
            parameters["files_id"] = fileID
        }
        self.startProcessing()
        RequestManager.editRecipe(recipeID: self.recipeID!, parameters: parameters) { (result) in
            self.stopProcessing()
            switch result {
            case .success(let data):
                self.performSegue(withIdentifier: "GotoIngredientsSegue", sender: data)
            case .error(let error):
                Constants.showAlert("Error", message: error.description)
            }
        }
        
    }
    
    fileprivate func validateRecipeCategory() -> Bool {
        for category in categoryArray {
            if category.isSelected == true {
                isCategoryChoosen = true
                break
            } else {
                isCategoryChoosen = false
            }
        }
        
        if !isCategoryChoosen {
            self.showError(withStatus: "You forgot to choose category!")
            return false
        } else {
            return true
        }
    }
    
    fileprivate func getSelectedCategories() -> String {
        let selectedCategories = categoryArray.filter({ return $0.isSelected })
        var categoriesIDs = [String]()
        selectedCategories.forEach { (category) in
            categoriesIDs.append("\(category.categoryID!)")
        }
        return categoriesIDs.joined(separator: ",")
    }
    
    fileprivate func setCategoriesUnselected() {
        for category in categoryArray {
            category.isSelected = false
        }
    }
    
    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoIngredientsSegue" {
            if let vc:AddIngredientsVC = segue.destination as? AddIngredientsVC {
                if let recipe = sender as? Recipe {
                    vc.recipe = recipe
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension AddNewRecipeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryPickCell", for: indexPath) as! CategoryPickCVCell
        let category = categoryArray[indexPath.row]
        cell.configureCell(data: category)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = categoryCollectionView.cellForItem(at: indexPath) as! CategoryPickCVCell
        let isSelected = categoryArray[indexPath.row].isSelected
        categoryArray[indexPath.row].isSelected = !isSelected
        cell.configureCell(data: categoryArray[indexPath.row])
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: categoryCollectionView.frame.size.width/2, height: 55)
    }
    
}
