//
//  LoginVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginVC: UIViewController, LoginButtonDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passErrorLabel: UILabel!
    
    var email = ""
    var pass = ""
    
    var verifyError = "Email verification required!"
    var invalidError = "Invalid Email Address"
    
    override func viewDidLoad() {
        super.viewDidLoad();
       
        setUp()
    }
    
    func setUp(){
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        emailTF.delegate = self
        passwordTF.delegate = self
        
        emailErrorLabel.isHidden = true
        emailErrorLabel.text = invalidError
        passErrorLabel.isHidden = true
        
        let loginButton = FBLoginButton()
        let newCenter = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 180)
        loginButton.center = newCenter
        loginButton.delegate = self
        loginButton.permissions = ["public_profile", "email"]
        view.addSubview(loginButton)
        
        if let token = AccessToken.current, !token.isExpired || Auth.auth().currentUser != nil{
            
            toHomeScreen()
        }
    }
    
    @IBAction func registerTapped(_ sender: UIButton) {
        let regVC = self.storyboard?.instantiateViewController(withIdentifier: "regStepOne") as! RegStepOneVC
        present(regVC, animated: true, completion: nil)
        
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        if(email != "" && pass != ""){
            signInUser(email: email, pass: pass)
        }
        
    }
    
    @IBAction func emailEditChanged(_ sender: UITextField) {
        email = sender.text ?? ""
        
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { (signInMethods, error) in
            if(error != nil){
                print(error!.localizedDescription)
                self.emailErrorLabel.isHidden = false
                
            } else{
                self.emailErrorLabel.isHidden = true
                
            }
        })
        
    }
    
    @IBAction func passEditChange(_ sender: UITextField) {
        pass = passwordTF.text ?? ""
        if(pass == ""){
            passErrorLabel.isHidden = false
        }
        
    }
    private func toHomeScreen(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = mainStoryboard
            .instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    
    func signInUser(email: String, pass: String){
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    
                    self.showToast(message: "Sign In has been disabled by admins.")
                    
                case .userDisabled:
                    
                    self.showToast(message: "This account is disabled.")
                    
                case .wrongPassword:
                    
                    self.passErrorLabel.isHidden = false
                    
                case .invalidEmail:
                    
                    self.emailErrorLabel.text = self.invalidError
                    self.emailErrorLabel.isHidden = false
                    
                default:
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                if(Auth.auth().currentUser?.isEmailVerified == true){
                    self.passErrorLabel.isHidden = true
                    self.emailErrorLabel.isHidden = true
                    self.emailErrorLabel.text = self.invalidError
                    
                    self.showToast(message: "Sign In Successful!")
                    self.email = ""
                    self.pass = ""
                    
                    let _ = Auth.auth().currentUser
                    self.toHomeScreen()
                } else{
                    self.emailErrorLabel.isHidden = false
                    self.emailErrorLabel.text = self.verifyError
                }
            }
            
        }
        
    }
    
    //facebook login method
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email, name"], tokenString: token, version: nil, httpMethod: .get)
        
        request.start(completionHandler: {connection, result, error in
            if(result != nil){
                
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                Auth.auth().signIn(with: credential) { (authResult, error) in
                    if let error = error {
                        print(error)
                    }
                    self.toHomeScreen()
                }
                
            } else {
                print("Result was nil")
            }
            
        })
    }
    
    //required function
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out.")
    }
    
    //keyboard handling
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if(textField == emailTF){
            print("EMAIL TEXT FIELD")
            passwordTF.becomeFirstResponder()
        } else if(textField == passwordTF){
            print("PASSWORD TEXT FIELD")
            passwordTF.resignFirstResponder()
            if(email != "" && pass != ""){
                signInUser(email: email, pass: pass)
            }
        }
        
        return true
    }
}
