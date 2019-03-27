//
//  SignInVC.swift
//  EasyMeals
//
//  Created by Максим on 2/20/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit
import CryptoSwift

class SignInVC: ParentVC {
    
    // MARK: - IBOutlets

    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var signUpBtn: DesignableButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInBtn: DesignableButton!
    @IBOutlet weak var restoreBtn: UIButton!
    
    // MARK: - IBActions

    @IBAction func signInBtnTap(_ sender: DesignableButton) {
        performSignInRequest(email: emailTextField.text!, password: passwordTextField.text!)
    }
    
    @IBAction func restoreBtnTap(_ sender: UIButton) {
    }
    
    // MARK: - Override properties
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

//        #if DEBUG
//        emailTextField.text = "axik02@gmail.com"
//        passwordTextField.text = "Pass1234"
//        #endif
        
        setUpView()

//        if let password = Constants.keychainInstance.get(Constants.keychainKeys.keyForLoginPassword), let email = Constants.keychainInstance.get(Constants.keychainKeys.keyForLoginEmail) {
//            performSignInRequest(email: email, password: password)
//        }
    }
    
    // MARK: - Private functions
    
    private func setUpView() {
        let logoLabelBounds = logoLabel.bounds
        logoLabel.bounds = CGRect(x: logoLabelBounds.maxX + 5, y: logoLabelBounds.maxY + 5, width: logoLabelBounds.width + 10, height: logoLabelBounds.height + 10)
        setUpTextFields()
    }
    
    private func setUpTextFields() {
        emailTextField.textContentType = .emailAddress
        passwordTextField.textContentType = .password
    }
    
    private func performSignInRequest(email: String, password: String) {
        let parameters = [
            "device_token"  : Constants.deviceToken,
            "email"         : email, //emailTextField.text!,
            "password"      : password.sha256(), //passwordTextField.text!.sha256()
            ] as JSONParameters
        
        self.startProcessing()
        RequestManager.signIn(parameters: parameters) { [weak self] (result) in
            guard let self = self else { return }
            self.stopProcessing()
            switch result {
            case .success(_):
                Constants.keychainInstance.set(email, forKey: Constants.keychainKeys.keyForLoginPassword)
                Constants.keychainInstance.set(password, forKey: Constants.keychainKeys.keyForLoginPassword)
                self.getCategoriesAndPresentMainVC()
            case .error(let error):
                Constants.showAlert("Error", message: error.localizedDescription)
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
    
//    private func updateView(withUserViewModel userViewModel: UserViewModel) {
//                emailTextField.text = userViewModel.userEmailText
//    }

    // MARK: - Override ParentVC functions

    @objc override func kbWillShow(_ notification: Notification) {
        guard isKeyboardShown == false else { return }
        
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        kbSizeHeight = kbFrameSize.height
        if let constraint = viewBottomConstraint {
            curViewBotConstant = constraint.constant
            constraint.constant = kbFrameSize.height + curViewBotConstant// + 20
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        if let scroll = scrollView  {
            curScrollOffset = scroll.contentOffset
            UIView.animate(withDuration: 0.3) {
                scroll.contentOffset = CGPoint(x: 0, y: kbFrameSize.height / 6)
            }
        }
        
        self.isKeyboardShown = true
        
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

// MARK: - UIScrollView Delegate

extension SignInVC {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
                    scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height)
            }
        }
    }
    
}
