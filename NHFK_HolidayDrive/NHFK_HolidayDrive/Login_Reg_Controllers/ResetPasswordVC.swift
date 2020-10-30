//
//  ResetPasswordVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/29/20.
//

import Foundation
import UIKit
import FirebaseAuth

class ResetPasswordVC: UIViewController{
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTF: UITextField!
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorLabel.isHidden = true
    }
    
    //Send reset password email after field is validated.
    @IBAction func passwordReset(_ sender: UIButton) {
        
        if(!email.isEmpty && Utility.checkEmailFormat(email) == true){
            
            self.errorLabel.isHidden = true
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if error == nil{
                    
                } else{
                    print(error!.localizedDescription)
                }
            }
        }
        else{
            self.errorLabel.isHidden = false
            
        }
    }
    
    
    //check user text as it is entered for valid email
    @IBAction func editChanged(_ sender: UITextField) {
        email = sender.text ?? ""
        
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { (signInMethods, error) in
            if(error != nil){
                print(error!.localizedDescription)
                self.errorLabel.isHidden = false
                
            } else if(signInMethods != nil){
                self.errorLabel.isHidden = true
            }
        })
    }
    
    
}
