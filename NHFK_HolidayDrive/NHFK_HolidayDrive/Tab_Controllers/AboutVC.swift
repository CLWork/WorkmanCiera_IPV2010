//
//  AboutVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class AboutVC: UIViewController{
    
    @IBOutlet weak var editBarBttn: UIBarButtonItem!
    
    var type = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkType()
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
                        
                    } else{
                        self.editBarBttn.isEnabled = false
                        self.editBarBttn.tintColor = .clear
                    }
                    
                    print(self.type)
                    
                } else {
                    
                    print("User does not exist. This should not happen.")
                    
                }
            }
    }
}
