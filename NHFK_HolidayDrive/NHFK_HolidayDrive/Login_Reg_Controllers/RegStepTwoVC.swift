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

class RegStepTwoVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var addressOne: UITextField!
    @IBOutlet weak var addressTwo: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipcodeTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    
    var passedUser: Users?
    let stateArray = Utility.populateStateArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statePicker = UIPickerView()
        statePicker.delegate = self
        stateTF.inputView = statePicker
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
        let state = stateTF.text ?? ""
        
        if(address1!.isEmpty){
            showToast(message: "Please enter an address or press Skip")
        } else if(city!.isEmpty){
            showToast(message: "Please enter a city or press Skip")
        }
        else if(state.isEmpty){
            
            showToast(message: "Please enter a State or press Skip")
            
        } else if(zipcode!.isEmpty || zipcode!.count > 5){
            
            showToast(message: "Please enter a zipcode or press Skip")
            
        }else{
            if(!address2!.isEmpty){
                address1 = address1! + " " + address2!
            }
            
            passedUser?.setAddressLineOne(a1: address1!)
            passedUser?.setCity(c: city!)
            passedUser?.setState(s: state)
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
    
    func alertUser(){
        
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stateArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return stateArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTF.text = stateArray[row]
    }
    

}
