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
import FirebaseStorage
import FirebaseFirestore

class AccountVC: UIViewController{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var addressL1: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var statsBarBttn: UIBarButtonItem!
    let storage = Storage.storage()
    var type = ""
    var address1 = ""
    var address2 = ""
    var city = ""
    var state = ""
    var zipcode = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = Notification.Name("didReceiveData")
        NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveData(_:)), name: name, object: nil)
        
        setUp()
        
    }
    
    func setUp(){
        nameLabel.font = UIFont(name: "DancingScript-SemiBold", size: 30)
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        readUserProfile()
        getProfileImage()
    }
    
    @objc func onDidReceiveData(_ notification:Notification) {
        // Do something now
        setUp()
    }
    
    //Pull the User's Firebase profile based on their Auth UID and populate the labels.
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
                    self.zipcode = document.get("zipcode") as? Int ?? 09876
                    self.type = document.get("type") as? String ?? "user"
                    
                    if(name != nil){
                        self.nameLabel.text = name
                        self.emailLabel.text = email
                        self.addressL1.text = self.address1 + " " + self.address2
                        self.cityLabel.text = self.city + ", " + self.state + " " + self.zipcode.description
                        
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
    
    //Pull Image from Storage based on UID of the current user and populate the ImageView with it.
    func getProfileImage(){
        guard let currentUserID = Auth.auth().currentUser?.uid else{
            return
        }
        let imgRef = storage.reference().child("profileImg/\(currentUserID).jpg")
        
        imgRef.downloadURL { (url, error) in
            if error != nil{
                
                print(error!.localizedDescription)
                self.showToast(message: "There was a problem retrieving your profile image.")
                
            } else{
                
                guard let url = url else{
                    return
                }
                
                
               let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data, error == nil else{
                        print(error!.localizedDescription)
                        return
                    }
                    DispatchQueue.main.async {
                        
                        
                        let image = UIImage(data: data)
                        self.profileImage.image = image
                    }
                }
                task.resume()
            }
        }
    }
    
    //Sign out the user
    @IBAction func signOutTapped(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        let fbSession = AccessToken.current
        
        do {
            if(fbSession != nil){
                let manager = LoginManager()
                manager.logOut()
            } else{
                try firebaseAuth.signOut()
            }
            toLoginScreen()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
    }
    
    //Redirect user to login screen upon successful signout
    func toLoginScreen(){
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let viewController = mainStoryboard
            .instantiateViewController(withIdentifier: "login")
        UIApplication.shared.windows.first?.rootViewController = viewController
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}
