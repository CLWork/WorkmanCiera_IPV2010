//
//  EditChildVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit

class EditChildVC: UIViewController{
    
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
        
        nameErrorLabel.isHidden = true
        ageErrorLabel.isHidden = true
        programErrorLabel.isHidden = true
        interestErrorLabel.isHidden = true
        
        
        
        setUp()
    }
    
    func setUp(){
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        if(passedChild != nil){
            
            nameTF.text = passedChild!.getName()
            ageTF.text = passedChild!.getAge().description
            
            switch passedChild!.getProgram(){
            case "Grief":
                griefButton.isSelected = true
                wishButton.isSelected = false
                griefButton.tintColor = .systemBlue
                griefButton.setTitleColor(.systemBlue, for: .selected)
            case "Wish":
                wishButton.isSelected = true
                griefButton.isSelected = false
                wishButton.tintColor = .systemBlue
                wishButton.setTitleColor(.systemBlue, for: .selected)
            default:
                griefButton.tintColor = .systemGray2
                griefButton.setTitleColor(.black, for: .selected)
                wishButton.tintColor = .systemGray2
                wishButton.setTitleColor(.black, for: .selected)
                griefButton.isSelected = false
                wishButton.isSelected = false
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
    
}
