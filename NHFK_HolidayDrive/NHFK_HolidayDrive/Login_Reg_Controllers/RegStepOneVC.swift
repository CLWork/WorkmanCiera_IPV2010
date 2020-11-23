//
//  RegStepOneVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage

class RegStepOneVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    //outlets
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPassTF: UITextField!
    @IBOutlet weak var codeTF: UITextField!
    @IBOutlet weak var nameErrorLabel: UILabel!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var passMatchErrorLabel: UILabel!
    @IBOutlet weak var codeErrorLabel: UILabel!
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    //variables
    var newUser: Users?
    let picker = UIImagePickerController()
    let storage = Storage.storage()
    let emailInUse = "Email already in use."
    let invalidEmail = "Invalid Email Format: Expecting test@domain.com"
    var pass = ""
    var confirmPass = ""
    var fullName = ""
    var email = ""
    var code = ""
    var type = ""
    var imgURL = NSURL()
    
    //control bools
    var nameValid = false
    var emailValid = false
    var passValid = false
    var passMatches = false
    var codeValid = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUp()
    }
    
    func setUp(){
        
        self.hideKeyboard()
        
        //hide all error labels
        nameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        passMatchErrorLabel.isHidden = true
        codeErrorLabel.isHidden = true
        
        profileImage.layer.masksToBounds = false
        profileImage.layer.cornerRadius = profileImage.frame.height/2
        profileImage.clipsToBounds = true
        
        profileImage.isUserInteractionEnabled = true
        let imgTapReg = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        profileImage.addGestureRecognizer(imgTapReg)
        picker.delegate = self
        
        fullNameTF.delegate = self
        emailTF.delegate = self
        passwordTF.delegate = self
        confirmPassTF.delegate = self
        codeTF.delegate = self
    }
    
    //validate input upon button tap
    @IBAction func continueTapped(_ sender: UIButton) {
        validateInput()
    }
    
    //validate each input
    func validateInput(){
        continueButton.isEnabled = false
        continueButton.backgroundColor = .systemGray
        
        //disable textfields to prevent any editing after Continue has been pressed
        fullNameTF.isEnabled = false
        emailTF.isEnabled = false
        passwordTF.isEnabled = false
        confirmPassTF.isEnabled = false
        codeTF.isEnabled = false
        
        //final check for valid entries just in case
        if(nameValid && emailValid && passValid && passMatches && codeValid){
            code = codeTF.text ?? ""
            newUser = Users(fName: fullName, userEmail: email)
            newUser?.setType(t: checkType(code: code))
            createNewUser(e: email, p: pass, newUser: newUser!)
            
        } else{
            
            //Enable editing if an error occurs.
            fullNameTF.isEnabled = true
            emailTF.isEnabled = true
            passwordTF.isEnabled =  true
            confirmPassTF.isEnabled = true
            codeTF.isEnabled = true
            showToast(message: "Something went wrong, please check your entries.")
            
            continueButton.isEnabled = true
            continueButton.backgroundColor = UIColor(red: 211/255.0, green: 57.0/255.0, blue: 67.0/255.0, alpha: 1.0)
            
        }
        
        
    }
    
    @objc
    func changeImage(){
        if(UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)){
            picker.sourceType = .savedPhotosAlbum
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        profileImage.backgroundColor = .none
        self.profileImage.image = image
        
        self.dismiss(animated: true) {
        }
    }
    
    func storeImage(uid: String){
        
        guard profileImage.image != nil else{
            return
        }
        
        guard let imageData = profileImage.image?.jpegData(compressionQuality: 1.0) else{
            return
        }
        self.storage.reference().child("profileImg/\(uid).jpg").putData(imageData, metadata: nil) { (_, error) in
            guard error == nil else{
                return
            }
        }
        
    }
    
    //checks for name validity as the user types
    @IBAction func nameEditChanged(_ sender: UITextField) {
        fullName = fullNameTF.text ?? ""
        if(fullName.count < 6 || fullName.isEmpty){
            nameErrorLabel.isHidden = false
            nameValid = false
        } else{
            nameErrorLabel.isHidden = true
            nameValid = true
        }
    }
    
    //checks for email validity as user types
    @IBAction func emailEditChanged(_ sender: UITextField) {
        email = sender.text ?? ""
        
        Auth.auth().fetchSignInMethods(forEmail: email, completion: { (signInMethods, error) in
            if(error != nil){
                print(error!.localizedDescription)
                self.emailErrorLabel.isHidden = false
                self.emailValid = false
                
            } else if(signInMethods != nil){
                self.emailErrorLabel.text = self.emailInUse
                self.emailErrorLabel.isHidden = false
                self.emailValid = false
            } else{
                self.emailErrorLabel.text = self.invalidEmail
                self.emailErrorLabel.isHidden = true
                self.emailValid = true
            }
        })
        
    }
    
    //Check for validity as the user types their password
    @IBAction func passEditChanged(_ sender: Any) {
        pass = passwordTF.text ?? ""
        
        if(Utility.checkPasswordStrength(p: pass) == false || pass.isEmpty){
            passwordErrorLabel.isHidden = false;
            passValid = false
        } else{
            passwordErrorLabel.isHidden = true;
            passValid = true
        }
    }
    
    //Check for validity as a user types their matching password
    @IBAction func passMatchEditChanged(_ sender: Any) {
        confirmPass = confirmPassTF.text ?? ""
        
        if(Utility.comparePass(p: pass, p2: confirmPass) == false || confirmPass.isEmpty){
            passMatchErrorLabel.isHidden = false
            passMatches = false
        } else{
            passMatchErrorLabel.isHidden = true
            passMatches = true
        }
    }
    
    @IBAction func codeDidChange(_ sender: UITextField) {
        code = codeTF.text ?? ""
        type = checkType(code: code)
    }
    
    //Add user profile to DB
    func addUserToDB(newUser: Users, uid: String){
        
        let db = Firestore.firestore()
        let ref = db.collection("users")
        
        var _: DocumentReference? = nil
        _ = ref.addDocument(data: newUser.getUserDic()) { err in
            if let err = err {
                print("Error adding document: \(err)")
                self.showToast(message: "Error in creating User Profile, please try again.")
            } else {
                self.showToast(message: "User Profile Created!")
                
                //clear password variables
                self.pass = ""
                self.confirmPass = ""
                
                //move to address step after user is successfully added to database
                self.performSegue(withIdentifier: "toStepTwo", sender: self)
            }
        }
        
    }
    
    //Create the user with Auth,send verification email
    func createNewUser(e: String, p: String, newUser: Users){
        
        Auth.auth().createUser(withEmail: e, password: p) { (authResult, error) in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                
                case .emailAlreadyInUse:
                    self.showToast(message: "This email is already in use.")
                    
                case .invalidEmail:
                    
                    self.showToast(message: "Oops! Email is in wrong format.")
                default:
                    print("Error: \(error.localizedDescription)\n\r \(error.description)")
                }
            } else {
                
                Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        self.showToast(message: "Error Sending Verification Email! Please try again.")
                        
                        return
                    }
                    self.storeImage(uid: Auth.auth().currentUser!.uid)
                    
                    self.addUserToDB(newUser: newUser, uid: Auth.auth().currentUser!.uid)
                })
            }
        }
    }
    
    //determine user type based on code entry
    func checkType(code: String) -> String{
        let codeString = "e9gt968irL"
        if(!code.isEmpty){
            
            if(code == codeString){
                codeValid = true
                codeErrorLabel.isHidden = true
                return "admin"
                
            } else{
                codeValid = false
                codeErrorLabel.isHidden = false
                return "user"
            }
            
        } else{
            codeValid = true
            return "user"
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField.tag{
        case 0:
            passwordTF.becomeFirstResponder()
        case 1:
            confirmPassTF.becomeFirstResponder()
        case 2:
            codeTF.becomeFirstResponder()
        default:
            view.endEditing(true)
        }
        return true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStepTwo" {
            if let stepTwo = segue.destination as? RegStepTwoVC {
                if let u = newUser{
                    stepTwo.passedUser = u
                }
            }
        }
    }
}
