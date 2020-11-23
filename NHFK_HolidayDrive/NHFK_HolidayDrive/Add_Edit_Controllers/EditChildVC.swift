//
//  EditChildVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseFirestore

class EditChildVC: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var interest1: UITextField!
    @IBOutlet weak var interest2: UITextField!
    @IBOutlet weak var interest3: UITextField!
    @IBOutlet weak var interest4: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var ageErrorLabel: UILabel!
    @IBOutlet weak var programErrorLabel: UILabel!
    @IBOutlet weak var interestErrorLabel: UILabel!
    @IBOutlet weak var griefButton: UIButton!
    @IBOutlet weak var wishButton: UIButton!
    
    var passedChild: Child?
    var interestOne: String?
    var interestTwo: String?
    var interestThree: String?
    var interestFour: String?
    var program = ""
    var name = ""
    var age = 0
    var beforeCheckInterestArray = [String]()
    var checkedArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp(){
        
        self.hideKeyboard()
        
        nameErrorLabel.isHidden = true
        ageErrorLabel.isHidden = true
        programErrorLabel.isHidden = true
        interestErrorLabel.isHidden = true
        griefButton.setTitleColor(.systemBlue, for: .selected)
        wishButton.setTitleColor(.systemBlue, for: .selected)
        griefButton.setTitleColor(.systemGray2, for: .normal)
        wishButton.setTitleColor(.systemGray2, for: .normal)
        
        nameTF.delegate = self
        ageTF.delegate = self
        interest1.delegate = self
        interest2.delegate = self
        interest3.delegate = self
        interest4.delegate = self
        
        if(passedChild != nil){
            
            nameTF.text = passedChild!.getName()
            ageTF.text = passedChild!.getAge().description
            
            switch passedChild!.getProgram(){
            case "Center For Grieving Children":
                griefButton.isSelected = true
                wishButton.isSelected = false
                griefButton.tintColor = .systemBlue
                wishButton.tintColor = .systemGray2
                
            case "Wishes For Kids":
                wishButton.isSelected = true
                griefButton.isSelected = false
                wishButton.tintColor = .systemBlue
                griefButton.tintColor = .systemGray2
                
            default:
                return
            }
            
            if(passedChild!.getInterests().count > 0){
                let interestArray = passedChild!.getInterests()
                
                interestOne = interestArray[0] ?? ""
                interestTwo = interestArray[1] ?? ""
                interestThree = interestArray[2] ?? ""
                interestFour = interestArray[3] ?? ""
                
                interest1.text = interestOne
                interest2.text = interestTwo
                interest3.text = interestThree
                interest4.text = interestFour
            }
            
        }
    }
    
    func findChildDoc(){
        var docID = ""
        
        guard passedChild != nil else{
            return
        }
        Firestore.firestore()
            .collection("children").whereField("id", isEqualTo: passedChild!.getID()).getDocuments { (snapshot, error) in
                guard error == nil else{
                    return
                }
                
                for document in snapshot!.documents{
                    docID = document.documentID
                    let id = document.get("id") as? Int
                    
                    guard id != nil, id == self.passedChild!.getID() else{
                        return
                    }
                    self.updateDoc(docID: docID)
                    
                }
            }
    }
    
    func updateDoc(docID: String){
        guard passedChild != nil else{
            return
        }
        Firestore.firestore().collection("children").document(docID).setData(passedChild!.getChildDic())
    }
    
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
    
    @IBAction func interestDidChange(_ sender: UITextField) {
        
        switch sender.tag{
        
        case 2:
            interestOne = interest1.text ?? ""
        case 3:
            interestTwo = interest2.text ?? ""
        case 4:
            interestThree = interest3.text ?? ""
        case 5:
            interestFour = interest4.text ?? ""
        default:
            return
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        
    }
    @IBAction func cancelPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func checkIntersts(){
        beforeCheckInterestArray.removeAll()
        checkedArray.removeAll()
        
        beforeCheckInterestArray.append(interestOne ?? "")
        beforeCheckInterestArray.append(interestTwo ?? "")
        beforeCheckInterestArray.append(interestThree ?? "")
        beforeCheckInterestArray.append(interestFour ?? "")
        
        for i in beforeCheckInterestArray {
            if(i != ""){
                checkedArray.append(i)
            }
        }
        
        if(checkedArray.count > 0){
            passedChild!.setInterests(interests: checkedArray)
            interestErrorLabel.isHidden = true
        } else{
            interestErrorLabel.isHidden = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        switch textField.tag {
        case 0:
            ageTF.becomeFirstResponder()
        case 1:
            interest1.becomeFirstResponder()
        case 2:
            interest2.becomeFirstResponder()
        case 3:
            interest3.becomeFirstResponder()
        case 4:
            interest4.becomeFirstResponder()
        default:
            view.endEditing(true)
        }
        
        return true
    }
    
}
