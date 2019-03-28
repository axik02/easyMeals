//
//  RestorePasswordVC.swift
//  EasyMeals
//
//  Created by Максим on 3/28/19.
//  Copyright © 2019 Yobibyte. All rights reserved.
//

import UIKit

class RestorePasswordVC: ParentVC {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var restoreBtn: UIButton!
    
    @IBAction func restoreButtonTap(_ sender: UIButton) {
        self.startProcessing(withStatus: "Sending recovery link...")
        RequestManager.restorePassword(withEmail: emailTextField.text!) { (responseString) in
            self.stopProcessing()
            Constants.showAlert(nil, message: responseString)
        }
    }
    
    @IBAction func backButtonTap(_ sender: UIButton) {
        onParentBack()
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
