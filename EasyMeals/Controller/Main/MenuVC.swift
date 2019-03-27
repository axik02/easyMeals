//
//  RecipeVC.swift
//  EasyMeals
//
//  Created by Максим on 2/20/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit
import AudioToolbox

class MenuVC: ParentVC {
    
    // MARK: Outlets

    @IBOutlet weak var daysCollectionView: UICollectionView!
    @IBOutlet weak var contentCollectionView: UICollectionView!
    @IBOutlet weak var bgView: UIView!
    
    var daysArray = ["sunday", "monday", "tuesday", "wednesday", "thursday",
                     "friday", "saturday"]
    
    // MARK: - IBActions

    @IBAction func shareBtnTap(_ sender: UIButton) {
    }
    
    @IBAction func settingsBtnTap(_ sender: UIButton) {
        self.performSegue(withIdentifier: "GotoPreferencesVC", sender: nil)
    }
    
    @IBAction func saladBtnTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func recipeBookBtnTap(_ sender: UIButton) {
    }
        
    // MARK: Variables
    
    private var responseInProgress = false
    private var prevIndexPath = IndexPath(row: 0, section: 0)
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        daysCollectionView.invalidateIntrinsicContentSize()
        contentCollectionView.invalidateIntrinsicContentSize()
    }

    
    // MARK: - UIEvent Motion
    
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            print("Shaked")
            guard responseInProgress == false else { return }
            responseInProgress = true
            
            RequestManager.menuGenerate { (result) in
                self.responseInProgress = false
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
                switch result {
                case .success(_):
                    self.showSuccess(withStatus: "Menu successfully generated.")
                    self.contentCollectionView.reloadData()
                case .error(let error):
                    self.showError(withStatus: error.localizedDescription)
                }
            }
            
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

extension MenuVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case daysCollectionView:
            return daysArray.count
        case contentCollectionView:
            return daysArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = daysArray[indexPath.row]
        switch collectionView {
        case daysCollectionView:
            let cell = daysCollectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath) as! CommonTopCVCell
            cell.configureCell(withDay: day)
            
            if indexPath != prevIndexPath {
                cell.nameLabel.textColor = #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
            } else {
                cell.nameLabel.textColor = #colorLiteral(red: 0.9568627451, green: 0.4705882353, blue: 0.2078431373, alpha: 1)
            }
            
            return cell
        case contentCollectionView:
            //All breakfast lunch dinner snacks
            let cell = contentCollectionView.dequeueReusableCell(withReuseIdentifier: "ContentCell", for: indexPath) as! MenuContentCVCell
            cell.parentVCDelegate = self
            cell.menuGetRecipe(withDay: day)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case daysCollectionView:
            prevIndexPath = indexPath
            contentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            daysCollectionView.reloadData()
        default:
            return
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case daysCollectionView:
            let font = UIFont(name: "Avenir-Medium", size: 22)!
            let day = daysArray[indexPath.row]
            let textWidth = day.widthOfString(usingFont: font)
            return CGSize(width: textWidth + 20, height: daysCollectionView.frame.size.height)
        case contentCollectionView:
            return CGSize(width: contentCollectionView.frame.size.width, height: contentCollectionView.frame.size.height)
        default:
            return CGSize()
        }
    }
    
}

// MARK: - UIScrollViewDelegate

extension MenuVC {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView {
        case contentCollectionView:

            let pageWidth = contentCollectionView.frame.size.width
            let currentPage = contentCollectionView.contentOffset.x / pageWidth

            if (0.0 != fmodf(Float(currentPage), 1.0))
            {
                let isIndexValid = daysArray.indices.contains(Int(currentPage + 1))
                if isIndexValid {
                    daysCollectionView.scrollToItem(at: IndexPath(item: Int(currentPage + 1), section: 0), at: .centeredHorizontally, animated: true)
                    prevIndexPath = IndexPath(item: Int(currentPage + 1), section: 0)
                }
            } else {
                daysCollectionView.scrollToItem(at: IndexPath(item: Int(currentPage), section: 0), at: .centeredHorizontally, animated: true)
                prevIndexPath = IndexPath(item: Int(currentPage), section: 0)
            }
            daysCollectionView.reloadData()

        default:
            return
        }
    }
}
