//
//  LoadingVC.swift
//  EasyMeals
//
//  Created by Максим on 2/26/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class LoadingVC: ParentVC {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleSegue()
    }
    
    private func handleSegue() {
        self.startProcessing()
        TokenHandler.shared.silentlyRefreshTokens { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.getCategoriesAndPresentMainVC()
            case .error(_):
                self.presentAuthNavigationVC()
            }
        }
    }
    
    fileprivate func getCategoriesAndPresentMainVC() {
        self.startProcessing()
        RequestManager.getCategories(complete: { [weak self] (result) in
            guard let self = self else { return }
            self.stopProcessing()
            switch result {
            case .success(let data):
                let categoriesViewModel = CategoriesViewModel(categories: data)
                Constants.categoriesViewModel = categoriesViewModel
                Constants.presentMainVCWith(currentVC: self)
            case .error(_):
                self.getCategoriesAndPresentMainVC()
            }
        })
    }

    
    fileprivate func presentAuthNavigationVC() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50), execute: {
            self.stopProcessing()
            self.performSegue(withIdentifier: "GotoAuthNavigationVC", sender: nil)
        })
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
