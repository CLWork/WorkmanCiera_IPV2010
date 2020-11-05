//
//  AddChildVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseFirestore

class AddChildVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var programTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var interest1TF: UITextField!
    @IBOutlet weak var interest2TF: UITextField!
    @IBOutlet weak var interest3TF: UITextField!
    @IBOutlet weak var interest4TF: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var ageErrorLabel: UILabel!
    @IBOutlet weak var programErrorLabel: UILabel!
    @IBOutlet weak var interestErrorLabel: UILabel!
    @IBOutlet weak var genderErrorLabel: UILabel!
    
    
    var name = ""
    var age = 0
    var program = ""
    var gender = ""
    var interest1 = ""
    var interest2 = ""
    var interest3 = ""
    var interest4 = ""
    var id = 0
    var wishCount = 0
    var griefCount = 0
    let programArray = ["Grief", "Wish"]
    let genderArray = ["Boy", "Girl"]
    var interestArray = [" "]
    
    var nameValid = false
    var ageValid = false
    var interestValid = false
    var programValid = false
    let programPicker = UIPickerView()
    let genderPicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        programPicker.delegate = self
        programTF.inputView = programPicker
        
        genderPicker.delegate = self
        genderTF.inputView = genderPicker
        
        
        nameErrorLabel.isHidden = true
        ageErrorLabel.isHidden = true
        programErrorLabel.isHidden = true
        interestErrorLabel.isHidden = true
        genderErrorLabel.isHidden = true
        programErrorLabel.isHidden = true
        
    }
    
    //PULL INFO
    //pull information from the database
    func getChildrenFromDB(){
        
        let db = Firestore.firestore()
        
        db.collection("children").getDocuments { (snapshot, error ) in
            
            if(error != nil){
                print(error!.localizedDescription)
            } else{
                
                for document in snapshot!.documents{
                    
                    let program = document.get("program") as? String
                    if(program != nil){
                        if(program == "Wish"){
                            self.wishCount += 1
                        } else if(program == "Grief"){
                            self.griefCount += 1
                        }
                    }
                }
            }
            
        }
    }
    
    //POPULATE
    
    //CHECK
    func validateInput(){
        
        if(!name.isEmpty && age > 0 && !program.isEmpty && !gender.isEmpty){
            interestArray.remove(at: 0)
            
        if(program == "Wish"){
            wishCount += 1
        } else if(program == "Grief"){
            griefCount += 1
        }
        
            let addedChild = Child(id: id, name: name, age: age, program: program, gender: gender, interests: interestArray)
        
        //save to database
        Firestore.firestore().collection("children").addDocument(data: addedChild.getChildDic())
       
        } else{
            if(gender.isEmpty){
                genderErrorLabel.isHidden = false
            }
            if(program.isEmpty){
                programErrorLabel.isHidden = false
            } else{
                showToast(message: "Please check your entries!")
            }
        }
    }
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        validateInput()
    }
    //SAVE
    @IBAction func nameDidChange(_ sender: UITextField) {
        name = nameTF.text ?? ""
        if(name.count > 3 && !name.isEmpty){
            nameErrorLabel.isHidden = true
            nameValid = true
        } else{
            nameErrorLabel.isHidden = false
            nameValid = false
        }
        
        print(nameValid)
    }
    
    @IBAction func ageDidChange(_ sender: UITextField) {
        let ageString = ageTF.text ?? ""
        if((Int(ageString)) != nil){
            age = Int(ageString)!
            
            ageErrorLabel.isHidden = true
            ageValid = true
            
        } else{
            
            ageErrorLabel.isHidden = false
            ageValid = false
            
        }
        
        print(ageValid)
    }
    
    @IBAction func interest3DidChange(_ sender: UITextField) {
        switch(sender.tag){
        case 0:
            interest1 = interest1TF.text ?? "None"
            interestValid = true
            interestArray.append(interest1)
        case 1:
            interest2 = interest2TF.text ?? "None"
            interestValid = true
            interestArray.append(interest2)
        case 2:
            interest3 = interest3TF.text ?? "None"
            interestValid = true
            interestArray.append(interest3)
        case 3:
            interest4 = interest4TF.text ?? "None"
            interestValid = true
            interestArray.append(interest4)
        default:
            interestValid = false
            return
        }
        
        print(interestValid)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView{
        case programPicker:
            return programArray.count
        case genderPicker:
            return genderArray.count
        default:
            return programArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView{
        case programPicker:
            return programArray[row]
        case genderPicker:
            return genderArray[row]
        default:
            return programArray[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        
        switch pickerView{
        case programPicker:
            program = programArray[row]
            programTF.text = programArray[row]
            if(program == "Wish"){
                id = 1000 + wishCount
            } else if(program == "Grief"){
                id = 2000 + griefCount
            }
        case genderPicker:
            genderTF.text = genderArray[row]
            gender = genderArray[row]
        default:
            return
        }
    }
}
