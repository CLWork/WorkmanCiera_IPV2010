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
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        self.errorLabel.isHidden = true
    }
    
    //Send reset password email after field is validated.
    @IBAction func passwordReset(_ sender: UIButton) {
        
        if(!email.isEmpty && Utility.checkEmailFormat(email) == true){
            
            self.errorLabel.isHidden = true
            
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if error != nil{
                    print(error!.localizedDescription)
                } else{
                    self.alertUser()
                }
            }
        }
        else{
            self.errorLabel.isHidden = false
            
        }
    }
    
    //dismiss the controller on cancel
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
    
    //let user know of success.
    func alertUser(){
        
        let alert = UIAlertController(title: "Reset Email Sent", message: "Please check your email for your reset link.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
