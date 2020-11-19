//
//  EditAccountVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class EditAccountVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate & UINavigationControllerDelegate{
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var addressOneTF: UITextField!
    @IBOutlet weak var addressTwoTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zipcodeTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var address1ErrorLabel: UILabel!
    @IBOutlet weak var address2ErrorLabel: UILabel!
    @IBOutlet weak var cityErrorLabel: UILabel!
    @IBOutlet weak var stateErrorLabel: UILabel!
    @IBOutlet weak var zipErrorLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
    var currentUser: Users?
    let picker = UIImagePickerController()
    let storage = Storage.storage()
    let emailInUse = "Email already in use."
    let invalidEmail = "Please enter a valid email."
    let notifName = Notification.Name("didReceiveData")
    
    var address1 = ""
    var address2 = ""
    var city = ""
    var state = ""
    var zipcode = 10000
    var email = ""
    var name = ""
    var isEmailInUse = false
    
    let stateArray = Utility.populateStateArray()
    
    let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-#" + " ")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    //inital set up
    func setUp(){
        
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        let statePicker = UIPickerView()
        statePicker.delegate = self
        stateTF.inputView = statePicker
        
        address1ErrorLabel.isHidden = true
        address2ErrorLabel.isHidden = true
        cityErrorLabel.isHidden = true
        stateErrorLabel.isHidden = true
        zipErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        nameErrorLabel.isHidden = true
        
        profileImage.backgroundColor = .lightGray
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        profileImage.isUserInteractionEnabled = true
        let imgTapReg = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        profileImage.addGestureRecognizer(imgTapReg)
        picker.delegate = self
        
        readUserProfile()
        getProfileImage()
    }
    
    //read current user profile
    func readUserProfile(){
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        db.collection("users").document(currentUser!.uid)
            .getDocument { (snapshot, error ) in
                
                if let document = snapshot {
                    self.name = document.get("fullName") as? String ?? ""
                    self.email = document.get("email") as? String ?? ""
                    self.address1 = document.get("addressLineOne") as? String ?? ""
                    self.address2 = document.get("addressLineTwo") as? String ?? ""
                    self.city = document.get("city") as? String ?? ""
                    self.state = document.get("state") as? String ?? ""
                    self.zipcode = document.get("zipcode") as? Int ?? 10000
                    
                    
                    self.fullNameTF.text = self.name
                    self.emailTF.text = self.email
                    self.addressOneTF.text = self.address1
                    self.stateTF.text = self.state
                    self.addressTwoTF.text = self.address2
                    self.cityTF.text = self.city
                    self.stateTF.text = self.state
                    self.zipcodeTF.text = self.zipcode.description
                    
                    self.currentUser = Users(fName: self.name, userEmail: self.email)
                    self.currentUser?.setAddressLineOne(a1: self.address1)
                    self.currentUser?.setAddressLineTwo(a2: self.address2)
                    self.currentUser?.setCity(c: self.city)
                    self.currentUser?.setZipcode(z: self.zipcode)
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
    
    //pulls up image picker on profile click
    @objc
    func changeImage(){
        if(UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)){
            picker.sourceType = .savedPhotosAlbum
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
            
        }
    }
    
    //Use picked image, set it to image view, save it to storage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        profileImage.backgroundColor = .none
        self.profileImage.image = image
        
        self.dismiss(animated: true, completion: nil)
        
        guard profileImage.image != nil else{
            return
        }
        
        guard let imageData = profileImage.image?.jpegData(compressionQuality: 1.0) else{
            return
        }
        self.storage.reference().child("profileImg/\(Auth.auth().currentUser!.uid).jpg").putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else{
                return
            }
        }
    }
    
    //Validate input upon button click
    func validateInput(){
        guard name != "", email != "", Utility.checkEmailFormat(email) == true, isEmailInUse == false else{
            if name == ""{
                nameErrorLabel.isHidden = false}
            if(isEmailInUse){
                emailErrorLabel.text = emailInUse
                emailErrorLabel.isHidden = false
            } else if email == ""{
                emailErrorLabel.text = invalidEmail
                emailErrorLabel.isHidden = false
            }
            return}
        
        address1ErrorLabel.isHidden = true
        address2ErrorLabel.isHidden = true
        cityErrorLabel.isHidden = true
        stateErrorLabel.isHidden = true
        zipErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        nameErrorLabel.isHidden = true
        
        currentUser?.setAddressLineOne(a1: address1)
        currentUser?.setAddressLineTwo(a2: address2)
        currentUser?.setCity(c: city)
        currentUser?.setState(s: state)
        currentUser?.setZipcode(z: zipcode)
        
        updateUserProfile()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifName.rawValue), object: nil)
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    //sends email if it's different than the one on file
    func updateUserEmail(){
        let updatedEmail = emailTF.text ?? email
        if(updatedEmail != email && updatedEmail != ""){
            Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                if(error != nil){
                    print(error!.localizedDescription)
                } else{
                    self.currentUser?.setEmail(e: updatedEmail)
                    self.showToast(message: "Email updated to: \(updatedEmail)")
                    Auth.auth().currentUser?.sendEmailVerification(completion: nil)
                    
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    //Dismisses the edit screen
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Sends inputs back through final validation check
    @IBAction func savePressed(_ sender: Any) {
        validateInput()
        
    }
    
    //checks for email validity as user types
    @IBAction func emailEditChanged(_ sender: UITextField) {
        email = sender.text ?? ""
        
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { (signInMethods, error) in
            if(error != nil){
                print(error!.localizedDescription)
                self.emailErrorLabel.isHidden = false
                
            } else if(signInMethods != nil){
                self.emailErrorLabel.text = self.emailInUse
                self.emailErrorLabel.isHidden = false
                self.isEmailInUse = true
                
            } else{
                self.emailErrorLabel.text = self.invalidEmail
                self.emailErrorLabel.isHidden = true
                self.isEmailInUse = false
            }
        })
        
    }
    
    //Real-time comparison of entry to ensure validity
    @IBAction func addOneEditChanged(_ sender: UITextField) {
        address1 = addressOneTF.text ?? ""
        
        if address1.rangeOfCharacter(from: characterset.inverted) != nil{
            address1ErrorLabel.isHidden = false
            
        }else{
            address1ErrorLabel.isHidden = true
            
        }
    }
    
    //Real-time comparison of entry to ensure validity
    @IBAction func addTwoEditChanged(_ sender: UITextField) {
        address2 = addressTwoTF.text ?? ""
        
        if address2.rangeOfCharacter(from: characterset.inverted) != nil{
            address2ErrorLabel.isHidden = false
            
        } else{
            address2ErrorLabel.isHidden = true
            
        }
    }
    
    //Real-time comparison of entry to ensure validity
    @IBAction func cityEditChanged(_ sender: UITextField) {
        city = cityTF.text ?? ""
        
        if city.rangeOfCharacter(from: characterset.inverted) != nil {
            cityErrorLabel.isHidden = false
            
        } else{
            cityErrorLabel.isHidden = true
            
        }
    }
    
    //Real-time comparison of entry to ensure validity
    @IBAction func zipEditChanged(_ sender: UITextField) {
        let zipcodeString = zipcodeTF.text ?? ""
        
        guard zipcodeString != "", zipcodeString.count == 5, zipcode == Int(zipcodeString) else{
            zipErrorLabel.isHidden = false
            return
        }
        zipErrorLabel.isHidden = true
        
    }
    
    //Push updates to database and overwrite the current document with current information
    func updateUserProfile(){
        
        if(currentUser != nil){
            let uid = Auth.auth().currentUser?.uid
            
            Firestore.firestore()
                .collection("users")
                .document(uid!).setData(currentUser!.getUserDic()) { (error) in
                    guard error == nil else{
                        self.showToast(message: "There was an error updating your profile, please try again.")
                        print(error!.localizedDescription)
                        return
                    }
                    
                    self.updateUserEmail()
                }
            
        } else{
            print("No user was passed.");
        }
        
    }
    
    //Picker Protocols
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return stateArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return stateArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stateTF.text = stateArray[row]
    }
}
