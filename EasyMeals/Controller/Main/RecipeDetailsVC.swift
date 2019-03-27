//
//  RecipeDetailsVC.swift
//  EasyMeals
//
//  Created by Максим on 2/21/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class RecipeDetailsVC: ParentVC {
    
    // MARK: - IBOutlets

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var ingredientsCollectionView: UICollectionView!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var detailsLabelBGView: UIView!
    @IBOutlet weak var ingredientsViewHeightConstraint: NSLayoutConstraint!
    
    // MARK: - IBActions
    
    @IBAction func backBtnTap(_ sender: UIButton) {
        onParentBack()
    }
    
    @IBAction func editBtnTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GotoAddNewRecipeVC", sender: self.recipeID)
    }
    
    @IBAction func shareBtnTap(_ sender: UIButton) {
        RequestManager.createRecipePDF(recipeID: recipeID) { (result) in
            switch result {
            case .success(let data):
                self.performSegue(withIdentifier: "GotoUrlPopUpVC", sender: data.downloadLink)
            case .error(let error):
                Constants.showAlert("Error", message: error.localizedDescription)
            }
        }
    }
    
    @IBAction func deleteBtnTap(_ sender: UIButton) {
    }
    
    // MARK: - Variables
    
    var recipeID:Int!
    private var recipeViewModel: RecipeViewModel!

    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.getRecipeData()
    }
    
    // MARK: - Private functions

    private func setupView() {
        addGradientLayer()
        addSwipeGestureRecognizer()
//        fixConstraints()
        
    }
    
    fileprivate func addGradientLayer() {
        let gradientLayer = CAGradientLayer()
        
        var uiColorsArr = [CGColor]()
        
        uiColorsArr.append(UIColor(hex: "021B79").cgColor)
        uiColorsArr.append(UIColor.clear.cgColor)
        
        gradientLayer.colors = uiColorsArr
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.frame = gradientView.bounds
        gradientLayer.frame.size.width = gradientLayer.frame.size.width + 50
        
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    fileprivate func fixConstraints() {
        self.detailsLabelBGView.safeAreaLayoutGuide.bottomAnchor.constraint(greaterThanOrEqualTo: self.detailsLabel.bottomAnchor, constant: 10).isActive = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        DispatchQueue.main.async {
            self.ingredientsViewHeightConstraint.constant = self.ingredientsCollectionView.contentSize.height
        }
    }
    
    fileprivate func addSwipeGestureRecognizer() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(self.performRightSwipe(_:)))
        swipe.direction = .right
        
        self.view.addGestureRecognizer(swipe)
    }
    
    @objc private func performRightSwipe(_ swipe: UISwipeGestureRecognizer) {
        onParentBack()
    }
    
    private func getRecipeData() {
        
        self.startProcessing()
        RequestManager.getRecipeByID(recipeID: self.recipeID) { (result) in
            self.stopProcessing()
            switch result {
            case .success(let data):
                self.recipeViewModel = RecipeViewModel(recipe: data)
                DispatchQueue.main.async {
                    self.setupView(WithRecipeViewModel: self.recipeViewModel)
                }
            case .error(let error):
                Constants.showAlert("Error", message: error.description)
            }
        }
    }
    
    fileprivate func setupView(WithRecipeViewModel recipeViewModel: RecipeViewModel) {
        self.nameLabel.text = recipeViewModel.recipeTitle
        self.recipeImageView.image = recipeViewModel.recipeImageView.image
        self.detailsLabel.text = recipeViewModel.recipeDescription
        self.categoriesCollectionView.reloadData()
        self.ingredientsCollectionView.reloadData()
        
        self.fixConstraints()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GotoAddNewRecipeVC" {
            if let addNewRecipeVC = segue.destination as? AddNewRecipeVC {
                if let recipeID = sender as? Int {
                    addNewRecipeVC.recipeID = recipeID
                }
            }
        }
        if segue.identifier == "GotoUrlPopUpVC" {
            if let urlPopUpVC = segue.destination as? URLPopUpVC {
                if let urlString = sender as? String {
                    urlPopUpVC.urlString = urlString
                }
            }
        }
        
    }
    

}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension RecipeDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoriesCollectionView:
            if recipeViewModel != nil {
                return recipeViewModel.categories.count
            }
            return 0
        case ingredientsCollectionView:
            if recipeViewModel != nil {
                return recipeViewModel.ingredients.count
            }
            return 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoriesCollectionView:
            let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CommonTopCVCell
            let category = recipeViewModel.categories[indexPath.row]
            cell.configureCell(withCategory: category)
            return cell
        case ingredientsCollectionView:
            let cell = ingredientsCollectionView.dequeueReusableCell(withReuseIdentifier: "IngredientCell", for: indexPath) as! IngredientCVCell
            let ingredient = recipeViewModel.ingredients[indexPath.row]
            cell.configureCell(withIngredient: ingredient)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case categoriesCollectionView:
            let category = recipeViewModel.categories[indexPath.row]
            let text = category.title ?? ""
            let stringFont = UIFont(name: "MyriadPro-Regular", size: 19)!
            let stringWidth = text.widthOfString(usingFont: stringFont)
            return CGSize(width: stringWidth + 40, height: 45)
        case ingredientsCollectionView:
            return CGSize(width: ingredientsCollectionView.frame.size.width / 2, height: 34)
        default:
            return CGSize.zero
        }
    }

}

// MARK: - UIScrollView Delegate

extension RecipeDetailsVC {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height)
            }
        }
    }
}
