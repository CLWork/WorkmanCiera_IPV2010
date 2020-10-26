//
//  AccountVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FBSDKLoginKit
import FirebaseFirestore

class AccountVC: UIViewController{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressL1: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipcodeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readUserProfile()
    }
    
    func readUserProfile(){
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        db.collection("users").document(currentUser!.uid)
            .getDocument { (snapshot, error ) in
                
                if let document = snapshot {
                    let name = document.get("fullName") as! String
                    let email = document.get("email") as! String
                    let addressOne = document.get("addressLineOne") as! String
                    let city = document.get("city") as! String
                    let state = document.get("state") as! String
                    let zipcode = document.get("zipcode") as! String
                    
                    self.nameLabel.text = name
                    self.emailLabel.text = email
                    self.addressL1.text = addressOne
                    self.cityLabel.text = city
                    self.stateLabel.text = state
                    self.zipcodeLabel.text = zipcode
                } else {
                    
                    print("Document does not exist")
                    
                }
            }
    }
    
    
    
    @IBAction func signOutTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            toLoginScreen()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    func toLoginScreen(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = mainStoryboard
            .instantiateViewController(withIdentifier: "login")
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
