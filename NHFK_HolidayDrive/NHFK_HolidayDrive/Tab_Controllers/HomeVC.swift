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
    
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var editBarBttn: UIBarButtonItem!
    @IBOutlet weak var hopeLabel: UILabel!
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkType()
        setUp()
    }
    
    func setUp(){
        hopeLabel.font = UIFont(name: "DancingScript-Bold", size: 35)
    }
    
    func checkType(){
            let db = Firestore.firestore()
            let currentUser = Auth.auth().currentUser
            db.collection("users").document(currentUser!.uid)
                .getDocument { (snapshot, error ) in
                    
                    if let document = snapshot {
                        self.type = document.get("type") as? String ?? "user"
                        if(self.type == "admin"){
                            self.editBarBttn.isEnabled = true
                            self.editBarBttn.tintColor = .systemBlue
                            self.navBar.isHidden = false
                        } else{
                            self.editBarBttn.isEnabled = false
                            self.editBarBttn.tintColor = .clear
                            self.navBar.isHidden = true
                        }
                        
                    } else {
                        
                        print("User does not exist. This should not happen.")
                        
                    }
                }
        }
    }
    
