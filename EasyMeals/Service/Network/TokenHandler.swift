//
//  TokenHandler.swift
//  EasyMeals
//
//  Created by Максим on 2/26/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class TokenHandler {
    
    private init() {}
    static let shared = TokenHandler()
    
    private weak var currentVC = UIApplication.topViewController()
    
    func silentlyRefreshTokens(complete: @escaping UserFetchCompleted) {
        RequestManager.refreshTokens { (result) in
            complete(result)
        }
    }
    
    func showSignInAlert() {
        
        let alert = UIAlertController(title: "Signature has expired!", message: "Please, login again.", preferredStyle: .alert)
        
        alert.addTextField { (emailTextField) in
            emailTextField.placeholder = "Email"
            emailTextField.keyboardType = .emailAddress
            emailTextField.textContentType = .emailAddress
            emailTextField.text = Constants.keychainInstance.get(Constants.keychainKeys.keyForLoginEmail)

        }
        
        alert.addTextField { (passwordTextField) in
            passwordTextField.placeholder = "Password"
            passwordTextField.keyboardType = .default
            passwordTextField.textContentType = .password
            passwordTextField.isSecureTextEntry = true

        }
        
        alert.addAction(image: nil, title: "Sign In", color: nil, style: .default, isEnabled: true) { (action) in
            let email = alert.textFields?.first?.text
            let password = alert.textFields?.last?.text
            
            self.performSignIn(email: email!, password: password!)
        }
        
        alert.addAction(image: nil, title: "Cancel", color: nil, style: .destructive, isEnabled: true) { (action) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.presentSignInVC()
            })
        }
    }
    
    private func performSignIn(email: String, password: String) {
        
        guard let parentVC = currentVC as? ParentVC else { return }

        let parameters = [
            "device_token"  : Constants.deviceToken,
            "email"         : email,
            "password"      : password.sha256(),
            ] as JSONParameters
        
        parentVC.startProcessing()
        RequestManager.signIn(parameters: parameters, complete: { (result) in
            switch result {
            case .success(_):
                parentVC.showSuccess()
                Constants.keychainInstance.set(email, forKey: Constants.keychainKeys.keyForLoginPassword)
                Constants.keychainInstance.set(password, forKey: Constants.keychainKeys.keyForLoginPassword)

            case .error(let error):
                parentVC.showError(withStatus: error.description)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                    self.presentSignInVC()
                })
            }
        })
    }
    
    private func presentSignInVC() {
            let storyboard = UIStoryboard(name: "Auth", bundle: nil)
            let vc:UINavigationController = storyboard.instantiateViewController(withIdentifier: "AuthNavigationVC") as! UINavigationController
        DispatchQueue.main.async {
            self.currentVC?.present(vc, animated: false, completion: nil)
        }
    }
    
}
