//
//  ViewController.swift
//  EasyMeals
//
//  Created by Максим on 09.07.2018.
//  Copyright © 2018 Yobibyte. All rights reserved.
//

import UIKit

class RecipeVC: ParentVC {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var mealsLabel: UILabel!
    
    // MARK: - IBActions

    @IBAction func saladBtnTap(_ sender: UIButton) {
    }
    
    @IBAction func recipeBookBtnTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GotoMenuVC", sender: nil)
    }
    
    // MARK: - Variables
    
    var categoriesViewModel = Constants.categoriesViewModel!
    private var dataArray = [""]
    private var prevIndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: - Override properties
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        categoryCollectionView.invalidateIntrinsicContentSize()
        contentCollectionView.invalidateIntrinsicContentSize()
    }
    
    // MARK: - Private functions
    
    private func setupView() {
        
        if dataArray.count == 0 {
            bgView.isHidden = true
        } else {
            bgView.isHidden = false
        }
        
        let logoLabelBounds = mealsLabel.bounds
        UIView.animate(withDuration: 0.3) {
            self.mealsLabel.bounds = CGRect(x: logoLabelBounds.maxX + 5, y: logoLabelBounds.maxY + 5, width: logoLabelBounds.width + 10, height: logoLabelBounds.height + 10)
        }
    }
    
    // MARK: - Prepare for segue
    
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

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout

extension RecipeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return categoriesViewModel.categoriesArray.count + 1
        case contentCollectionView:
            return categoriesViewModel.categoriesArray.count + 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case categoryCollectionView:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CommonTopCVCell
            if indexPath.row == 0 {
                cell.nameLabel.text = "All"
            } else {
                let category = categoriesViewModel.categoriesArray[indexPath.row - 1]
                cell.nameLabel.text = category.title
            }
            
            if indexPath != prevIndexPath {
                cell.nameLabel.textColor = #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
            } else {
                cell.nameLabel.textColor = #colorLiteral(red: 0.9568627451, green: 0.4705882353, blue: 0.2078431373, alpha: 1)
            }
            
            return cell
        case contentCollectionView:
            //All breakfast lunch dinner snacks
            let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! ContentCVCell
            cell.parentVCDelegate = self
            cell.setDefaultPages()
            if indexPath.row == 0 {
                cell.categoryID = nil
            } else {
                let category = categoriesViewModel.categoriesArray[indexPath.row - 1]
                cell.categoryID = category.categoryID
            }
            print(cell.categoryID)
            cell.getRecipe(page: 1)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case categoryCollectionView:
            
            prevIndexPath = indexPath
            contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            categoryCollectionView.reloadData()
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case categoryCollectionView:
            let font = UIFont(name: "Avenir-Medium", size: 22)!
            var textWidth: CGFloat
            if indexPath.row == 0 {
                textWidth = "All".widthOfString(usingFont: font)
                return CGSize(width: textWidth + 20, height: categoryCollectionView.frame.size.height)
            } else {
                let category = categoriesViewModel.categoriesArray[indexPath.row - 1]
                if let text = category.title  {
                    textWidth = text.widthOfString(usingFont: font)
                } else {
                    return CGSize(width: 20, height: categoryCollectionView.frame.size.height)
                }
            }
            return CGSize(width: textWidth + 20, height: categoryCollectionView.frame.size.height)
        case contentCollectionView:
            return CGSize(width: contentCollectionView.frame.size.width, height: contentCollectionView.frame.size.height)
        default:
            return CGSize()
        }
    }
}

// MARK: - UIScrollViewDelegate

extension RecipeVC {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case contentCollectionView:
            
            let pageWidth = contentCollectionView.frame.size.width
            let currentPage = contentCollectionView.contentOffset.x / pageWidth
            
            if (0.0 != fmodf(Float(currentPage), 1.0))
            {
                let isIndexValid = categoriesViewModel.categoriesArray.indices.contains(Int(currentPage + 1))
                if isIndexValid {
                    categoryCollectionView.scrollToItem(at: IndexPath(item: Int(currentPage + 1), section: 0), at: .centeredHorizontally, animated: true)
                    prevIndexPath = IndexPath(item: Int(currentPage + 1), section: 0)
                }
            } else {
                categoryCollectionView.scrollToItem(at: IndexPath(item: Int(currentPage), section: 0), at: .centeredHorizontally, animated: true)
                prevIndexPath = IndexPath(item: Int(currentPage), section: 0)
            }
            categoryCollectionView.reloadData()
            
        default:
            return
        }
    }
}
