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
    var zipcode = ""
    
    var address1Valid = false
    var address2Valid = true
    var cityValid = false
    var stateValid = false
    var zipValid = false
    
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-#" + " ")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statePicker = UIPickerView()
        statePicker.delegate = self
        stateTF.inputView = statePicker
        
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
        toHomeScreen()
    }
    
    
    
    func validateInput(){
        
        if(address1Valid && address2Valid && cityValid && stateValid && zipValid){
        passedUser?.setAddressLineOne(a1: address1)
        passedUser?.setAddressLineTwo(a2: address2)
        passedUser?.setCity(c: city)
        passedUser?.setState(s: state)
        passedUser?.setZipcode(z: zipcode)
        
        updateUserProfile()
        } else{
            self.showToast(message: "Oops! Please check your entries.")
        }
    }
    
    
    
    
    @IBAction func addOneEditChanged(_ sender: UITextField) {
        address1 = addressOne.text ?? ""
        
        if address1.rangeOfCharacter(from: characterset.inverted) != nil{
            address1ErrorLabel.isHidden = false
            address1Valid = false
        }else{
            address1ErrorLabel.isHidden = true
            address1Valid = true
        }
    }
    
    @IBAction func addTwoEditChanged(_ sender: UITextField) {
        address2 = addressTwo.text ?? ""
        
        if address2.rangeOfCharacter(from: characterset.inverted) != nil{
            address2ErrorLabel.isHidden = false
            address2Valid = false
        } else{
            address2ErrorLabel.isHidden = true
            address2Valid = true
        }
    }
    
    @IBAction func cityEditChanged(_ sender: UITextField) {
        city = cityTF.text ?? ""
        
        if city.rangeOfCharacter(from: characterset.inverted) != nil {
            cityErrorLabel.isHidden = false
            cityValid = false
        } else{
            cityErrorLabel.isHidden = true
            cityValid = true
        }
    }
    
    @IBAction func zipEditChanged(_ sender: UITextField) {
        zipcode = zipcodeTF.text ?? ""
        
        if(zipcode != "" && zipcode.count == 5){
            guard Int(zipcode) != nil else{
                zipcodeErrorLabel.isHidden = false
                zipValid = false
                return
            }
            zipcodeErrorLabel.isHidden = true
            zipValid = true
            
        } else{
            zipcodeErrorLabel.isHidden = false
            zipValid = false
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
    }
    
    
}
