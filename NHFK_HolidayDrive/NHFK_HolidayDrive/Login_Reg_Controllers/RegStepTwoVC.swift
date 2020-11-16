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
    
    @IBOutlet weak var address2ErrorLabel: UILabel!
    @IBOutlet weak var address1ErrorLabel: UILabel!
    @IBOutlet weak var cityErrorLabel: UILabel!
    @IBOutlet weak var stateErrorLabel: UILabel!
    @IBOutlet weak var zipcodeErrorLabel: UILabel!
    
    
    var passedUser: Users?
    let stateArray = Utility.populateStateArray()
    
    var address1 = ""
    var address2 = ""
    var city = ""
    var state = ""
    var zipcode = 0
    
    let addressSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-#" + " ")
    let citySet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" + " ")
    let zipcodeSet =  CharacterSet(charactersIn: "0123456789")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statePicker = UIPickerView()
        statePicker.delegate = self
        stateTF.inputView = statePicker
        stateTF.text = stateArray[0]
        state = stateArray[0]
        
        address1ErrorLabel.isHidden = true
        address2ErrorLabel.isHidden = true
        cityErrorLabel.isHidden = true
        stateErrorLabel.isHidden = true
        zipcodeErrorLabel.isHidden = true
    }
    
    
    @IBAction func finishTapped(_ sender: Any) {
        validateInput();
    }
    
    @IBAction func skipTapped(_ sender: UIButton) {
        updateUserProfile()
        
        alertUser()
    }
    
    
    
    func validateInput(){
        
        if(address1 != "" && city != "" && state != "" && zipcode > 0){
            
            address1ErrorLabel.isHidden = true
            address2ErrorLabel.isHidden = true
            cityErrorLabel.isHidden = true
            stateErrorLabel.isHidden = true
            zipcodeErrorLabel.isHidden = true
            
            passedUser?.setAddressLineOne(a1: address1)
            passedUser?.setAddressLineTwo(a2: address2)
            passedUser?.setCity(c: city)
            passedUser?.setState(s: state)
            passedUser?.setZipcode(z: zipcode)
            
            updateUserProfile()
        } else{
            self.showToast(message: "Oops! Please check your entries.")
            
            if(address1 == ""){
                address1ErrorLabel.isHidden = false
            }
            
            if(city == ""){
                cityErrorLabel.isHidden = false
            }
            
            if state == "" {
                stateErrorLabel.isHidden = false
            }
            
            if zipcode == 0 {
                zipcodeErrorLabel.isHidden = false
            }
        }
    }
    
    @IBAction func addOneEditChanged(_ sender: UITextField) {
        address1 = addressOne.text ?? ""
        
        if address1.rangeOfCharacter(from: addressSet.inverted) != nil{
            address1ErrorLabel.isHidden = false
           
        }else{
            address1ErrorLabel.isHidden = true
        }
        
    }
    
    @IBAction func addTwoEditChanged(_ sender: UITextField) {
        address2 = addressTwo.text ?? ""
        
        if address2.rangeOfCharacter(from: addressSet.inverted) != nil{
            address2ErrorLabel.isHidden = false
            
        } else{
            address2ErrorLabel.isHidden = true
            
        }
        
    }
    
    @IBAction func cityEditChanged(_ sender: UITextField) {
        city = cityTF.text ?? ""
        
        if city.rangeOfCharacter(from: citySet.inverted) != nil {
            cityErrorLabel.isHidden = false
            
        } else{
            cityErrorLabel.isHidden = true
           
        }
       
    }
    
    @IBAction func zipEditChanged(_ sender: UITextField) {
        let zipcodeString = zipcodeTF.text ?? ""
        
        if zipcodeString.rangeOfCharacter(from: zipcodeSet.inverted) != nil || zipcodeString.count > 5{
            zipcodeErrorLabel.isHidden = false
        } else{
            zipcode = Int(zipcodeString) ?? 0
            zipcodeErrorLabel.isHidden = true
        }
       
    }
    
    
    func updateUserProfile(){
        
        if(passedUser != nil){
            let uid = Auth.auth().currentUser?.uid
            
            Firestore.firestore()
                .collection("users")
                .document(uid!)
                .setData(passedUser!.getUserDic()) { [weak self] e in
                    guard let self = self else { return }
                    if e != nil {
                        print(e!.localizedDescription)
                    }
                    else {
                        self.alertUser()
                    }
                }
            
        } else{
            print("No user was passed.");
        }
        
    }
    
    func alertUser(){
        
        let alert = UIAlertController(title: "Welcome!", message: "Please make sure you verify your email. We'll direct you to the login screen now.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.toLoginScreen()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //Segues
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
    
    
    //Picker components
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
        state = stateArray[row]
    }
    
    
}
