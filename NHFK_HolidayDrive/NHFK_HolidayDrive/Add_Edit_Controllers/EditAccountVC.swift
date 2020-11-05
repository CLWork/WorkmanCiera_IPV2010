//
//  EditAccountVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditAccountVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressOneTF: UITextField!
    @IBOutlet weak var addressTwoTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipcodeTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var address1ErrorLabel: UILabel!
    @IBOutlet weak var address2ErrorLabel: UILabel!
    @IBOutlet weak var cityErrorLabel: UILabel!
    @IBOutlet weak var stateErrorLabel: UILabel!
    @IBOutlet weak var zipErrorLabel: UILabel!
    
    
    var currentUser: Users?
    let emailInUse = "Email already in use."
    let invalidEmail = "Please enter a valid email."
    
    var address1 = ""
    var address2 = ""
    var city = ""
    var state = ""
    var zipcode = ""
    var email = ""
    var name = ""
    
    let stateArray = Utility.populateStateArray()
    
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
        zipErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        nameErrorLabel.isHidden = true
        
        readUserProfile()
    }
    
    func readUserProfile(){
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        db.collection("users").document(currentUser!.uid)
            .getDocument { (snapshot, error ) in
                
                if let document = snapshot {
                    self.name = document.get("fullName") as? String ?? ""
                    self.email = document.get("email") as? String ?? ""
                    self.address1 = document.get("addressLineOne") as? String ?? ""
                    self.address2 = document.get("addressLineTwo") as? String ?? ""
                    self.city = document.get("city") as? String ?? ""
                    self.state = document.get("state") as? String ?? ""
                    self.zipcode = document.get("zipcode") as? String ?? ""
                    
                    
                    self.fullNameTF.text = self.name
                    self.emailTF.text = self.email
                    self.addressOneTF.text = self.address1
                    self.stateTF.text = self.state
                    self.addressTwoTF.text = self.address2
                    self.cityTF.text = self.city
                    self.stateTF.text = self.state
                    self.zipcodeTF.text = self.zipcode
                    
                    self.currentUser = Users(fName: self.name, userEmail: self.email)
                    
                } else {
                    
                    print("Document does not exist")
                    
                }
            }
    }
    
    func validateInput(){
        if(name != "" && email != "" && Utility.checkEmailFormat(email) == true){
        currentUser?.setAddressLineOne(a1: address1)
        currentUser?.setAddressLineTwo(a2: address2)
        currentUser?.setCity(c: city)
        currentUser?.setState(s: state)
        currentUser?.setZipcode(z: zipcode)
        
            updateUserProfile()}
        
    }
    
    func updateUserEmail(){
        let updatedEmail = emailTF.text ?? ""
        if(updatedEmail != email && updatedEmail != ""){
            Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                if(error != nil){
                    print(error!.localizedDescription)
                } else{
                    self.showToast(message: "Email updated to: \(updatedEmail)")
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func savePressed(_ sender: Any) {
        validateInput()
        
    }
    
    //checks for email validity as user types
    @IBAction func emailEditChanged(_ sender: UITextField) {
        email = sender.text ?? ""
        
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { (signInMethods, error) in
            if(error != nil){
                print(error!.localizedDescription)
                self.emailErrorLabel.isHidden = false
                //self.emailValid = false
                
            } else if(signInMethods != nil){
                self.emailErrorLabel.text = self.emailInUse
                self.emailErrorLabel.isHidden = false
                //self.emailValid = false
            } else{
                self.emailErrorLabel.text = self.invalidEmail
                self.emailErrorLabel.isHidden = true
                //self.emailValid = true
            }
        })
        
    }
    
    @IBAction func addOneEditChanged(_ sender: UITextField) {
        address1 = addressOneTF.text ?? ""
        
        if address1.rangeOfCharacter(from: characterset.inverted) != nil{
            address1ErrorLabel.isHidden = false
            
        }else{
            address1ErrorLabel.isHidden = true
            
        }
    }
    
    @IBAction func addTwoEditChanged(_ sender: UITextField) {
        address2 = addressTwoTF.text ?? ""
        
        if address2.rangeOfCharacter(from: characterset.inverted) != nil{
            address2ErrorLabel.isHidden = false
            
        } else{
            address2ErrorLabel.isHidden = true
            
        }
    }
    
    @IBAction func cityEditChanged(_ sender: UITextField) {
        city = cityTF.text ?? ""
        
        if city.rangeOfCharacter(from: characterset.inverted) != nil {
            cityErrorLabel.isHidden = false
            
        } else{
            cityErrorLabel.isHidden = true
            
        }
    }
    
    @IBAction func zipEditChanged(_ sender: UITextField) {
        zipcode = zipcodeTF.text ?? ""
        
        if(zipcode != "" && zipcode.count == 5){
            guard Int(zipcode) != nil else{
                zipErrorLabel.isHidden = false
                return
            }
            zipErrorLabel.isHidden = true
            
        } else{
            zipErrorLabel.isHidden = false
            
        }
        
    }
    
    
    
    
    func updateUserProfile(){
        
        if(currentUser != nil){
            let uid = Auth.auth().currentUser?.uid
            
            Firestore.firestore()
                .collection("users")
                .document(uid!)
                .setData(currentUser!.getUserDic()) { [weak self] e in
                    guard self != nil else { return }
                    if e != nil {
                        print(e!.localizedDescription)
                    }
                    else {
                       print("Profile Updated")
                    }
                }
            
            updateUserEmail()
            
        } else{
            print("No user was passed.");
        }
        
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
