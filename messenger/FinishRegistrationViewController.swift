//
//  FinishRegistrationViewController.swift
//  messenger
//
//  Created by Andrew Li on 3/31/19.
//  Copyright © 2019 Andrew Li. All rights reserved.
//

import UIKit
import ProgressHUD

class FinishRegistrationViewController: UIViewController {
    
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    var email: String!
    var password: String!
    var avatarImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(email, password)

    }

    @IBAction func tryprint(_ sender: Any) {
        print("I pressed the try button")
    }
    //MARK: IBActions
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        print("I pressed the cancel button")
        cleanTextFields()
        dismissKeyBoard()
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        print("I pressed the done button")
        dismissKeyBoard()
        ProgressHUD.show("Registering...")
        
        if nameTextField.text != "" && lastNameTextField.text != "" && countryTextField.text != "" && cityTextField.text != "" && phoneTextField.text != "" {
            
            FUser.registerUserWith(email: email!, password: password!, firstName: nameTextField.text!, lastName: lastNameTextField.text!) { (error) in
                
                if error != nil {
                    
                    ProgressHUD.dismiss()
                    ProgressHUD.showError(error!.localizedDescription)
                    return
                }
                
                self.registerUser()
                
            }
        }else{
            ProgressHUD.showError("All Fields Are Required")
        }
    }
    
    
    //MARK: HELPERS
    
    func dismissKeyBoard() {
        self.view.endEditing(false)
    }
    
    func cleanTextFields() {
        nameTextField.text = ""
        lastNameTextField.text = ""
        countryTextField.text = ""
        phoneTextField.text = ""
        cityTextField.text = ""
    }
    
    func registerUser() {
        
        let fullName = nameTextField.text! + " " + lastNameTextField.text!
        
        var tempDictionary : Dictionary = [kFIRSTNAME : nameTextField.text!, kLASTNAME : lastNameTextField.text!, kFULLNAME : fullName, kCOUNTRY : countryTextField.text!, kCITY : cityTextField.text!, kPHONE : phoneTextField.text!] as [String: Any]
        
        
        if avatarImage == nil {
            
            imageFromInitials(firstName: nameTextField.text!, lastName: lastNameTextField.text!) { (avatarInitials) in
                
                let avatarIMG = avatarInitials.jpegData(compressionQuality: 0.7)
                let avatar = avatarIMG!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                
                tempDictionary[kAVATAR] = avatar
                
                self.finishRegistration(withValues: tempDictionary)
                
            }
            
        }else{
            
            let avatarData = avatarImage?.jpegData(compressionQuality: 0.7)
            let avatar = avatarData!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            
            tempDictionary[kAVATAR] = avatar
            
            self.finishRegistration(withValues: tempDictionary)
            
        }
        
    }
    
    func finishRegistration(withValues: [String: Any]) {
        
        updateCurrentUserInFirestore(withValues: withValues) { (error) in
    
        if error != nil{
            DispatchQueue.main.async {
                ProgressHUD.showError(error!.localizedDescription)
                print(error!.localizedDescription)
            }
            
            return
            
        }
        
            ProgressHUD.dismiss()
            goToApp()
        }
        
        func goToApp() {
            
            cleanTextFields()
            dismissKeyBoard()
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: USER_DID_LOGIN_NOTIFICATION), object: nil, userInfo: [kUSERID : FUser.currentId()])
            
            let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainApplication") as! UITabBarController
            
            self.present(mainView, animated: true, completion: nil)
            
        }
        
}

}
