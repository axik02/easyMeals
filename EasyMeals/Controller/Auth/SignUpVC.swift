//
//  SignInVC.swift
//  EasyMeals
//
//  Created by Максим on 2/20/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit
import CryptoSwift

class SignUpVC: ParentVC {
    
    // MARK: - IBOutlets

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpBtn: DesignableButton!
    @IBOutlet weak var signInBtn: UIButton!
    
    // MARK: - IBActions

    @IBAction func backBtnTap(_ sender: UIButton) {
        onParentBack()
    }
    
    @IBAction func signUpBtnTap(_ sender: DesignableButton) {
        performSignUpRequest()
    }
    
    @IBAction func signInBtnTap(_ sender: UIButton) {
        onParentBack()
    }
    
    // MARK: - Override properties

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        
    }
    
    private func setUpView() {
        setUpTextFields()
    }
    
    private func setUpTextFields() {
        nameTextField.textContentType = .username
        emailTextField.textContentType = .emailAddress
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .newPassword
        } else {
            passwordTextField.textContentType = .password
        }
        confirmPasswordTextField.textContentType = .password
    }

    private func performSignUpRequest() {
        
        guard isValidPassword(password: passwordTextField.text!,
                              confirmPassword: confirmPasswordTextField.text!)
            else { return }
        
        let parameters = [
            "device_token"  : Constants.deviceToken,
            "user_name"     : nameTextField.text!,
            "email"         : emailTextField.text!,
            "password"      : passwordTextField.text!.sha256()
            ] as JSONParameters
        
        self.startProcessing()
        RequestManager.signUp(parameters: parameters) { [weak self] (result) in
            guard let self = self else { return }
            self.stopProcessing()
            switch result {
            case .success(_):
                Constants.keychainInstance.set(self.emailTextField.text!, forKey: Constants.keychainKeys.keyForLoginPassword)
                Constants.keychainInstance.set(self.passwordTextField.text!, forKey: Constants.keychainKeys.keyForLoginPassword)
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

    
    fileprivate func isValidPassword(password: String, confirmPassword: String) -> Bool {
        if password != confirmPassword {
            Constants.showAlert("Error", message: "Passwords don't match!")
            return false
        }
        
        if password.count < 7 {
            Constants.showAlert("Error", message: "Your password is too small. It has to contain at least 7 symbols.")
            return false
        }
        
        return true

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

extension SignUpVC {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height)
            }
        }
    }
}
