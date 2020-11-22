//
//  SponsorDonateVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 11/4/20.
//

import Foundation
import UIKit

class SponsorDonateVC: UIViewController{
    
    @IBOutlet weak var donateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var amt25Bttn: UIButton!
    @IBOutlet weak var amt100Bttn: UIButton!
    @IBOutlet weak var amt500Bttn: UIButton!
    
    var donateAmount = 0.00
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    //set font
    func setUp(){
        donateLabel.font = UIFont(name: "DancingScript-SemiBold", size: 50)
        donateLabel.text = "$\(donateAmount.description)"
        amt25Bttn.setTitleColor(.systemBlue, for: .selected)
        amt100Bttn.setTitleColor(.systemBlue, for: .selected)
        amt500Bttn.setTitleColor(.systemBlue, for: .selected)
        
    }
    

    
    //dismiss controller
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func donateBttnPressed(_ sender: UIButton) {
        
        switch sender.tag{
        case 0:
            amt25Bttn.isSelected = true
            amt100Bttn.isSelected = false
            amt500Bttn.isSelected = false
            
        case 1:
            amt25Bttn.isSelected = false
            amt100Bttn.isSelected = true
            amt500Bttn.isSelected = false
        case 2:
            amt25Bttn.isSelected = false
            amt100Bttn.isSelected = false
            amt500Bttn.isSelected = true
        default:
            return
        }
    }
    
    //tell the user their donation was successful.
    func alertUser(amount: String){
        
        let alert = UIAlertController(title: "Thank You!", message: "We have recieved your donation of $\(amount)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Great!", style: .default, handler: { action in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
