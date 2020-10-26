//
//  RegStepTwoVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class RegStepTwoVC: UIViewController{
    
    @IBOutlet weak var addressOne: UITextField!
    @IBOutlet weak var addressTwo: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipcodeTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    
    var passedUser: Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func finishTapped(_ sender: Any) {
        validateInput();
    }
    @IBAction func skipTapped(_ sender: UIButton) {
        updateUserProfile()
        toHomeScreen()
    }
    
    
    
    func validateInput(){
        var address1 = addressOne.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let address2 = addressTwo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let city = cityTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let zipcode = zipcodeTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let state = stateTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if(address1!.isEmpty){
            showToast(message: "Please enter an address or press Skip")
        } else if(city!.isEmpty){
            showToast(message: "Please enter a city or press Skip")
        }
        else if(state!.isEmpty || state!.count > 2){
            showToast(message: "Please enter a State or press Skip")
        } else if(zipcode!.isEmpty || zipcode!.count > 5){
            showToast(message: "Please enter a zipcode or press Skip")
        } else if(Utility.compareStates(state: state!) == false){
            showToast(message: "Please enter a state in format: FL")
        }else{
            if(!address2!.isEmpty){
                address1 = address1! + " " + address2!
            }
            
            passedUser?.setAddressLineOne(a1: address1!)
            passedUser?.setCity(c: city!)
            passedUser?.setState(s: state!)
            passedUser?.setZipcode(z: zipcode!)
            
            updateUserProfile()
        }
        
        
    }
    
    func updateUserProfile(){
        
        if(passedUser != nil){
            let uid = Auth.auth().currentUser?.uid
            
            Firestore.firestore()
                .collection("users")
                .document(uid!)
                .setData(passedUser!.getUserDic()) { [weak self] err in
                    guard let self = self else { return }
                    if let error = err {
                        print("err ... \(error)")

                    }
                    else {
                        self.showToast(message: "User profile created! Please verify your email to continue.")
                        self.toLoginScreen()
                    }
            }
            
        } else{
            print("No user was passed.");
        }
        
    }
    
    func toLoginScreen(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = mainStoryboard
            .instantiateViewController(withIdentifier: "login")
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func toHomeScreen(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = mainStoryboard
            .instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    

}
