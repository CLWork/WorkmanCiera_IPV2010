//
//  HomeVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeVC: UIViewController{
    
    @IBOutlet weak var hopeLabel: UILabel!
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp(){
        hopeLabel.font = UIFont(name: "DancingScript-Bold", size: 35)
    }
    
    
}

