//
//  RegStepOneVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class RegStepOneVC: UIViewController{
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func continueTapped(_ sender: UIButton) {
        validateInput()
    }
    
    func validateInput(){
        
        let fullName = fullNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? nil
        let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pass = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmPass = confirmPassTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let code = codeTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        let isEmailValid = Utility.checkEmailFormat(email!)
        let isPassStrong = Utility.checkPasswordStrength(p: pass!)
        let doPassMatch = Utility.comparePass(p: pass!, p2: confirmPass!)
        
        
        if(fullName == nil || fullName!.isEmpty){
            self.showToast(message: "Please enter your name!")
            
        } else if(email == nil || isEmailValid == false){
            self.showToast(message: "Email must be a valid format and not empty!")
            
        } else if(pass == nil || isPassStrong == false){
            self.showToast(message: "Password must be 8 characters long with 1 Uppercase, 1 Lowercase, 1 Number, 1 Special Character.")
            
        } else if(confirmPass == nil || doPassMatch == false){
            self.showToast(message: "Password must be confirmed, not empty and must match.")
        } else{
            let newUser = Users(fName: fullName!, userEmail: email!)
            newUser.setType(t: checkType(code: code!))
            
            createNewUser(e: email!, p: pass!, newUser: newUser)
            
            
        }
        
        
        
    }
    
    func addUserToDB(newUser: Users){
        let db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        
        do{
            try db.collection("users").document(uid!).setData(from: newUser)
            
        } catch{
            print(error)
           showToast(message: "Error in adding user to database.")
        }
        
        showToast(message: "User added to database!")
        
    }
    
    func createNewUser(e: String, p: String, newUser: Users){
        
        Auth.auth().createUser(withEmail: e, password: p) { (authResult, error) in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                
                case .emailAlreadyInUse:
                    self.showToast(message: "This email is already in use.")
                    
                case .invalidEmail:
                    
                    self.showToast(message: "Oops! Email is in wrong format.")
                default:
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                self.showToast(message: "User Created!")
                let _ = Auth.auth().currentUser
                addUserToDB(newUser: newUser)
            }
        }
    }
    
    func checkType(code: String) -> String{
        let codeString = "e9gt968irL"
        if(!code.isEmpty){
            
            if(code == codeString){
                return "admin"
            } else{
                return "user"
            }
            
        } else{
            return "user"
        }
        
    }
    
    func toRegStepTwo(){
        let regVC = self.storyboard?.instantiateViewController(withIdentifier: "regStepOne") as! RegStepTwoVC
        present(regVC, animated: true, completion: nil)
    }
    
}
