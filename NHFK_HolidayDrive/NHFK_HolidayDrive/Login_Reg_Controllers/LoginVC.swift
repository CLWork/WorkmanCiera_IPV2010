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

class LoginVC: UIViewController, LoginButtonDelegate{
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        let loginButton = FBLoginButton()
        let newCenter = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - 280)
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
        validateFields()
        
        
    }
    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        
        
        
        
    }
    private func toHomeScreen(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = mainStoryboard
            .instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    
    func validateFields(){
        
        let email = emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let isEmailValid = Utility.checkEmailFormat(email!)
        let isPassStrong = Utility.checkPasswordStrength(p: password!)
        
        if(isEmailValid == false || email == nil){
            
            self.showToast(message: "Please enter a valid email: email@domain.com")
            
        } else if(isPassStrong == false || password == nil){
            
            self.showToast(message: "Password must be 8 characters. 1 Uppercase, 1 Lowercase, 1 Number, 1 Special Character")
            
        } else{
            signInUser(email: email!, pass: password!)
            
        }
        
        
        
    }
    
    func signInUser(email: String, pass: String){
        Auth.auth().signIn(withEmail: email, password: pass) { (authResult, error) in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    
                    print("Unable to sign in with a email and password.")
                case .userDisabled:
                    
                    self.showToast(message: "This account has been disabled.")
                case .wrongPassword:
                    
                    self.showToast(message: "Oops! Incorrect password.")
                case .invalidEmail:
                    
                    self.showToast(message: "Oops! Email is in wrong format.")
                default:
                    print("Error: \(error.localizedDescription)")
                }
            } else {
                if(Auth.auth().currentUser?.isEmailVerified == true){
                    print("User signs in successfully")
                    let _ = Auth.auth().currentUser
                    self.toHomeScreen()
                } else{
                    self.showToast(message: "Oops! Your email hasn't been verified yet.")
                }
            }
            
        }
        
    }
    
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
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User logged out.")
    }
}
