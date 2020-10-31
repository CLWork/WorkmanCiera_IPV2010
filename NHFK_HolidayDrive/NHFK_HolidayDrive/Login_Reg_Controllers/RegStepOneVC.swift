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
    
    //outlets
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passMatchErrorLabel: UILabel!
    @IBOutlet weak var codeErrorLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    
    //variables
    var newUser: Users?
    let emailInUse = "Email already in use."
    let invalidEmail = "Please enter a valid email."
    var pass = ""
    var confirmPass = ""
    var fullName = ""
    var email = ""
    var code = ""
    
    //control bools
    var nameValid = false
    var emailValid = false
    var passValid = false
    var passMatches = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide all error labels
        nameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passMatchErrorLabel.isHidden = true
        codeErrorLabel.isHidden = true
    
    }
    
    //validate input upon button tap
    @IBAction func continueTapped(_ sender: UIButton) {
        validateInput()
    }
    
    //validate each input
    func validateInput(){
        
        //disable textfields to prevent any editing after Continue has been pressed
        fullNameTF.isEnabled = false
        emailTF.isEnabled = false
        passwordTF.isEnabled = false
        confirmPassTF.isEnabled = false
        codeTF.isEnabled = false
        
        //final check for valid entries just in case
        if(nameValid && emailValid && passValid && passMatches){
            code = codeTF.text ?? ""
            newUser = Users(fName: fullName, userEmail: email)
            newUser?.setType(t: checkType(code: code))
            createNewUser(e: email, p: pass, newUser: newUser!)
            
        } else{
            
            //Enable editing if an error occurs.
            fullNameTF.isEnabled = true
            emailTF.isEnabled = true
            passwordTF.isEnabled =  true
            confirmPassTF.isEnabled = true
            codeTF.isEnabled = true
            showToast(message: "Something went wrong, please check your entries.")
            
        }
        
        
    }
    
    //checks for name validity as the user types
    @IBAction func nameEditChanged(_ sender: UITextField) {
        fullName = fullNameTF.text ?? ""
        if(fullName.count < 6 || fullName.isEmpty){
            nameErrorLabel.isHidden = false
            nameValid = false
        } else{
            nameErrorLabel.isHidden = true
            nameValid = true
        }
    }
    
    //checks for email validity as user types
    @IBAction func emailEditChanged(_ sender: UITextField) {
        email = sender.text ?? ""
        
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { (signInMethods, error) in
            if(error != nil){
                print(error!.localizedDescription)
                self.emailErrorLabel.isHidden = false
                self.emailValid = false
                
            } else if(signInMethods != nil){
                self.emailErrorLabel.text = self.emailInUse
                self.emailErrorLabel.isHidden = false
                self.emailValid = false
            } else{
                self.emailErrorLabel.text = self.invalidEmail
                self.emailErrorLabel.isHidden = true
                self.emailValid = true
            }
        })
        
    }
    
    //Check for validity as the user types their password
    @IBAction func passEditChanged(_ sender: Any) {
        pass = passwordTF.text ?? ""
        
        if(Utility.checkPasswordStrength(p: pass) == false || pass.isEmpty){
            passwordErrorLabel.isHidden = false;
            passValid = false
        } else{
            passwordErrorLabel.isHidden = true;
            passValid = true
        }
    }
    
    //Check for validity as a user types their matching password
    @IBAction func passMatchEditChanged(_ sender: Any) {
        confirmPass = confirmPassTF.text ?? ""
        
        if(Utility.comparePass(p: pass, p2: confirmPass) == false || confirmPass.isEmpty){
            passMatchErrorLabel.isHidden = false
            passMatches = false
        } else{
            passMatchErrorLabel.isHidden = true
            passMatches = true
        }
    }
    
    
    //Add user profile to DB
    func addUserToDB(newUser: Users, uid: String){
        
        let db = Firestore.firestore()
        let ref = db.collection("users")
        
        var _: DocumentReference? = nil
        _ = ref.addDocument(data: newUser.getUserDic()) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.showToast(message: "Error in creating User Profile, please try again.")
            } else {
                self.showToast(message: "User Profile Created!")
                
                //clear password variables
                self.pass = ""
                self.confirmPass = ""
                
                //move to address step after user is successfully added to database
                self.performSegue(withIdentifier: "toStepTwo", sender: self)
            }
        }
        
    }
    
    //Create the user with Auth,send verification email
    func createNewUser(e: String, p: String, newUser: Users){
        
        Auth.auth().createUser(withEmail: e, password: p) { (authResult, error) in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                
                case .emailAlreadyInUse:
                    self.showToast(message: "This email is already in use.")
                    
                case .invalidEmail:
                    
                    self.showToast(message: "Oops! Email is in wrong format.")
                default:
                    print("Error: \(error.localizedDescription)\n\r \(error.description)")
                }
            } else {
                self.showToast(message: "User Created!")
                // let current = Auth.auth().currentUser
                //let uid = current?.uid
                
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.showToast(message: "Error Sending Verification Email! Please try again.")
                        
                        return
                    }
                    self.showToast(message: "Email Verification Sent!")
                    self.addUserToDB(newUser: newUser, uid: Auth.auth().currentUser!.uid)
                })
            }
        }
    }
    
    //determine user type based on code entry
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStepTwo" {
            if let stepTwo = segue.destination as? RegStepTwoVC {
                stepTwo.passedUser = newUser!
            }
        }
    }
}
