//
//  SponsorDonateVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 11/4/20.
//

import Foundation
import UIKit

class SponsorDonateVC: UIViewController{
    
    @IBOutlet weak var sponsorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //set font
    func setUp(){
        sponsorLabel.font = UIFont(name: "DancingScript-SemiBold", size: 50)
    }
    
    //send confirmation alert
    @IBAction func donationBttnTapped(_ sender: UIButton) {
        
        switch(sender.tag){
        case 0:
            alertUser(amount: "25")
        case 1:
            alertUser(amount: "100")
        case 2:
            alertUser(amount: "500")
        default:
            return
        }
    }
    
    //dismiss controller
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
