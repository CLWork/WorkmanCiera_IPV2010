//
//  EditChildVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit

class EditChildVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var programTF: UITextField!
    @IBOutlet weak var interest1: UITextField!
    @IBOutlet weak var interest2: UITextField!
    @IBOutlet weak var interest3: UITextField!
    @IBOutlet weak var interest4: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var ageErrorLabel: UILabel!
    @IBOutlet weak var programErrorLabel: UILabel!
    @IBOutlet weak var interestErrorLabel: UILabel!
    
    var passedChild: Child?
    var interestOne: String?
    var interestTwo: String?
    var interestThree: String?
    var interestFour: String?
    let programPicker = UIPickerView()
    let genderPicker = UIPickerView()
    let programArray = ["Grief", "Wish"]
    var program = ""
    var name = ""
    var age = 0
    var beforeCheckInterestArray = [String]()
    var checkedArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        programPicker.delegate = self
        programTF.inputView = programPicker
        
        nameErrorLabel.isHidden = true
        ageErrorLabel.isHidden = true
        programErrorLabel.isHidden = true
        interestErrorLabel.isHidden = true
        
        setUp()
    }
    
    func setUp(){
        if(passedChild != nil){
            
            nameTF.text = passedChild!.getName()
            ageTF.text = passedChild!.getAge().description
            programTF.text = passedChild!.getProgram()
            
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
    
    func updateChild(){
        
        
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
        
        case 0:
            interestOne = interest1.text ?? ""
        case 1:
            interestTwo = interest2.text ?? ""
        case 2:
            interestThree = interest3.text ?? ""
        case 3:
            interestFour = interest4.text ?? ""
        default:
            return
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        
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
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return programArray.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return programArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        program = programArray[row]
        programTF.text = programArray[row]
    }
}
