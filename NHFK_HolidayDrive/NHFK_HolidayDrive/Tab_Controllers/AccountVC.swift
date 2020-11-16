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
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var statsBarBttn: UIBarButtonItem!
    var type = ""
    var address1 = ""
    var address2 = ""
    var city = ""
    var state = ""
    var zipcode = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readUserProfile()
        
        nameLabel.font = UIFont(name: "DancingScript-SemiBold", size: 30)
        profileImage.backgroundColor = .lightGray
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        profileImage.isUserInteractionEnabled = true
        let imgTapReg = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        profileImage.addGestureRecognizer(imgTapReg)
    }
    
    func readUserProfile(){
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        db.collection("users").document(currentUser!.uid)
            .getDocument { (snapshot, error ) in
                
                if let document = snapshot {
                    let name = document.get("fullName") as? String
                    let email = document.get("email") as? String
                    self.address1 = document.get("addressLineOne") as? String ?? ""
                    self.address2 = document.get("addressLineTwo") as? String ?? ""
                    self.city = document.get("city") as? String ?? ""
                    self.state = document.get("state") as? String ?? ""
                    self.zipcode = document.get("zipcode") as? String ?? ""
                    self.type = document.get("type") as? String ?? "user"
                    
                    if(name != nil){
                        self.nameLabel.text = name
                        self.emailLabel.text = email
                        self.addressL1.text = self.address1 + " " + self.address2
                        self.cityLabel.text = self.city + ", " + self.state + " " + self.zipcode
                        
                        if(self.type == "admin"){
                            self.statsBarBttn.isEnabled = true
                            self.statsBarBttn.tintColor = .systemBlue
                        } else{
                            self.statsBarBttn.isEnabled = false
                            self.statsBarBttn.tintColor = .clear
                        }
                        
                    }
                } else {
                    
                    print("Document does not exist")
                    
                }
            }
    }
    @objc
    func changeImage(){
        
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
