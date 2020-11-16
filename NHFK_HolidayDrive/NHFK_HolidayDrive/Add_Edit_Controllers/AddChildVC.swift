//
//  AddChildVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseFirestore

class AddChildVC: UIViewController{
    
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var interest1TF: UITextField!
    @IBOutlet weak var interest2TF: UITextField!
    @IBOutlet weak var interest3TF: UITextField!
    @IBOutlet weak var interest4TF: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var ageErrorLabel: UILabel!
    @IBOutlet weak var programErrorLabel: UILabel!
    @IBOutlet weak var interestErrorLabel: UILabel!
    @IBOutlet weak var genderErrorLabel: UILabel!
    @IBOutlet weak var griefButton: UIButton!
    @IBOutlet weak var wishButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
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
    var interestArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                        if(program == self.wishButton.titleLabel?.description){
                            self.wishCount += 1
                        } else if(program == self.griefButton.titleLabel?.description){
                            self.griefCount += 1
                        }
                    }
                }
            }
            
        }
    }
    
    //CHECK
    func validateInput(){
        checkInterestArray()
        
        if(!name.isEmpty && age > 0 && !program.isEmpty && !gender.isEmpty && interestArray.count > 0){
            
            nameErrorLabel.isHidden = true
            ageErrorLabel.isHidden = true
            programErrorLabel.isHidden = true
            interestErrorLabel.isHidden = true
            genderErrorLabel.isHidden = true
            programErrorLabel.isHidden = true
            
            if(program == wishButton.titleLabel?.description){
                wishCount += 1
                id = 1000 + wishCount
            } else if(program == griefButton.titleLabel?.description){
                griefCount += 1
                id = 2000 + griefCount
            }
            
            let addedChild = Child(id: id, name: name, age: age, program: program, gender: gender, interests: interestArray)
            
            //save to database
            Firestore.firestore().collection("children").addDocument(data: addedChild.getChildDic())
            
            dismiss(animated: true, completion: nil)
            
        } else{
            if(gender.isEmpty){
                genderErrorLabel.isHidden = false
            }
            if(program.isEmpty){
                programErrorLabel.isHidden = false
            }
            if(name.isEmpty){
                nameErrorLabel.isHidden = false
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
            
        } else{
            
            nameErrorLabel.isHidden = false
        }
        
    }
    
    @IBAction func ageDidChange(_ sender: UITextField) {
        let ageString = ageTF.text ?? ""
        
        if((Int(ageString)) != nil){
            
            age = Int(ageString)!
            ageErrorLabel.isHidden = true
            
        } else{
            
            ageErrorLabel.isHidden = false
        }
        
       
    }
    
    @IBAction func programChosen(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            program = "Center For Grieving Children"
            griefButton.tintColor = .systemBlue
            griefButton.setTitleColor(.systemBlue, for: .selected)
            griefButton.isSelected = true
            
            wishButton.isSelected = false
            wishButton.tintColor = .systemGray2
            wishButton.setTitleColor(.systemGray2, for: .normal)
            
        case 1:
            program = "Wishes For Kids"
            wishButton.tintColor = .systemBlue
            wishButton.setTitleColor(.systemBlue, for: .selected)
            griefButton.isSelected = false
            
            wishButton.isSelected = true
            griefButton.tintColor = .systemGray2
            griefButton.setTitleColor(.systemGray2, for: .normal)
            
        default:
            program = "Center For Grieving Children"
            griefButton.tintColor = .systemBlue
            griefButton.setTitleColor(.systemBlue, for: .selected)
            griefButton.isSelected = true
            
            wishButton.isSelected = false
            wishButton.tintColor = .systemGray2
            wishButton.setTitleColor(.systemGray2, for: .normal)
        }
    }
    
    @IBAction func genderChosen(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            gender = "Girl"
            femaleButton.tintColor = .systemBlue
            femaleButton.setTitleColor(.systemBlue, for: .selected)
            femaleButton.isSelected = true
            
            maleButton.isSelected = false
            maleButton.tintColor = .systemGray2
            maleButton.setTitleColor(.systemGray2, for: .normal)
            
        case 1:
            gender = "Boy"
            maleButton.tintColor = .systemBlue
            maleButton.setTitleColor(.systemBlue, for: .selected)
            maleButton.isSelected = true
            
            femaleButton.isSelected = false
            femaleButton.tintColor = .systemGray2
            femaleButton.setTitleColor(.systemGray2, for: .normal)
            
        default:
            return
        }
    }
    
    
    @IBAction func interest3DidChange(_ sender: UITextField) {
        switch(sender.tag){
        case 0:
            interest1 = interest1TF.text ?? ""
            interestArray.append(interest1)
        case 1:
            interest2 = interest2TF.text ?? ""
            interestArray.append(interest2)
        case 2:
            interest3 = interest3TF.text ?? ""
            interestArray.append(interest3)
        case 3:
            interest4 = interest4TF.text ?? ""
            interestArray.append(interest4)
        default:
            interestErrorLabel.isHidden = true
            return
        }
    }
    
    func checkInterestArray(){
        var checkedArray = [String]()
        for i in interestArray{
            if i != "" {
                checkedArray.append(i)
            }
        }
        
        if checkedArray.count > 0{
            interestArray.removeAll()
            interestArray = checkedArray
        } else{
            interestErrorLabel.isHidden = false
        }
    }
    
}
