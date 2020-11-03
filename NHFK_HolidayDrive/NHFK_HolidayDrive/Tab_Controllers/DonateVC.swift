//
//  DonateVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit

class DonateVC: UIViewController, UIGestureRecognizerDelegate{
    
    @IBOutlet weak var supporterLabel: UILabel!
    @IBOutlet weak var sponsorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setFont()
    }
    
    func setFont(){
        supporterLabel.font = UIFont(name: "DancingScript-SemiBold", size: 40)
        sponsorLabel.font = UIFont(name: "DancingScript-SemiBold", size: 40)
    }
    
    @IBAction func supporterTapped(_ sender: UITapGestureRecognizer) {
        
        
        
    }
    @IBAction func sponsorTapped(_ sender: UITapGestureRecognizer) {
        
        
        
    }
}
