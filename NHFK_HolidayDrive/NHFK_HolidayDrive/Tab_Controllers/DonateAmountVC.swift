//
//  donateAmountVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 11/4/20.
//

import Foundation
import UIKit

class DonateAmountVC: UIViewController{
    
    
    @IBOutlet weak var donateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var donateAmountLabel: UILabel!
    @IBOutlet weak var donateSlider: UISlider!
    @IBOutlet weak var donateButton: UIButton!
    
    
    var selectedChild: Child?
    var donateTitle = "Donate"
    var donateToTitle = "Donate To"
    var donationAmnt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
        
    }
    
    //Set custom font, labels as needed
    func setUp(){
        donateLabel.font = UIFont(name: "DancingScript-SemiBold", size: 45)
        
        donateAmountLabel.text = "$" + donationAmnt.description
        donateButton.setTitle("Donate $\(donationAmnt.description)", for: .normal)
        
        if(donationAmnt == 0){
            donateButton.isEnabled = false
            donateButton.backgroundColor = .gray
        }
        
        if(selectedChild != nil){
            donateLabel.text = donateToTitle
            nameLabel.text = selectedChild!.getName()
        } else{
            donateLabel.text = donateTitle
            nameLabel.text = ""
        }
    }
    
    //Update labels as slider changes
    @IBAction func sliderChanged(_ sender: UISlider) {
        donationAmnt = Int(sender.value)
        donateAmountLabel.text = "$\(donationAmnt.description)"
        donateButton.setTitle("Donate $\(donationAmnt.description)", for: .normal)
        
        if(donationAmnt > 0){
            donateButton.isEnabled = true
            donateButton.backgroundColor = UIColor(red: 211/255.0, green: 57.0/255.0, blue: 67.0/255.0, alpha: 1.0)
        }
    }
    
    //dismiss controller
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //verify donation on press
    @IBAction func donateTapped(_ sender: UIButton) {
        
        alertUser()
    }
    
    //tell the user their donation was successful. 
    func alertUser(){
        
        let alert = UIAlertController(title: "Thank You!", message: "We have recieved your donation of $\(donationAmnt)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Great!", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
