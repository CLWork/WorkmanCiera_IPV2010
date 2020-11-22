//
//  ChildListVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChildListVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var addBarBttn: UIBarButtonItem!
    @IBOutlet weak var editBarBttn: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var type = ""
    var childrenArray = Array<Child>()
    let db = Firestore.firestore()
    var supportedChild: Child?
    var chosenChild: Child?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkType()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelectionDuringEditing = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getChildrenFromDB()
    }
    
    //determine if user can see bar button items
    func checkType(){
        let currentUser = Auth.auth().currentUser
        db.collection("users").document(currentUser!.uid)
            .getDocument { (snapshot, error ) in
                
                if let document = snapshot {
                    self.type = document.get("type") as? String ?? "user"
                    if(self.type == "admin"){
                        self.editBarBttn.isEnabled = true
                        self.editBarBttn.tintColor = .systemBlue
                        self.addBarBttn.isEnabled = true
                        self.addBarBttn.tintColor = .systemBlue
                        
                        
                    } else{
                        self.editBarBttn.isEnabled = false
                        self.editBarBttn.tintColor = .clear
                        self.addBarBttn.isEnabled = false
                        self.addBarBttn.tintColor = .clear
                    }
                    
                } else {
                    
                    print("User does not exist. This should not happen.")
                    
                }
            }
    }
    
    @IBAction func editTapped(_ sender: Any) {
        if(tableView.isEditing == false){
            tableView.isEditing = true
            editBarBttn.title = "Finish"
            
            
        } else if(tableView.isEditing == true){
            tableView.isEditing = false
            editBarBttn.title = "Edit"
        }
    }
    //pull information from the database
    func getChildrenFromDB(){
        
        childrenArray.removeAll()
        
        db.collection("children").getDocuments { (snapshot, error ) in
            
            if(error != nil){
                print(error!.localizedDescription)
            } else{
                
                for document in snapshot!.documents{
                    
                    
                    let id = document.get("id") as? Int
                    let name = document.get("name") as? String
                    let age = document.get("age") as? Int
                    let gender = document.get("gender") as? String
                    let program = document.get("program") as? String
                    let itemArray = document.get("items") as? [String]
                    
                    
                    if(name != nil){
                        if(itemArray != nil){
                            var interestArray = [String]()
                            var i = 0
                            while i < 4 && i < itemArray!.count{
                                interestArray.append(itemArray![i])
                                i+=1
                            }
                            
                            self.supportedChild = Child(id: id ?? 0, name: name!, age: age ?? 0, program: program ?? "Not Specified", gender: gender!, interests: interestArray)
                            
                            self.childrenArray.append(self.supportedChild!)
                            self.childrenArray.shuffle()
                            interestArray.removeAll()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
            
        }
    }
    
    //MARK: TableView Protocols
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childrenArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "child_cell", for: indexPath) as? ChildCell else {return tableView.dequeueReusableCell(withIdentifier: "child_cell", for: indexPath) }
        
        cell.childNameAge.text = childrenArray[indexPath.row].getName() + ", " + childrenArray[indexPath.row].getAge().description
        cell.childNameAge.font = UIFont(name: "DancingScript-SemiBold", size: 30)
        cell.program.text = childrenArray[indexPath.row].getProgram()
        
        let interests: [String?] = childrenArray[indexPath.row].getInterests()
        
        switch interests.count{
        case 1:
            cell.movie1.text = interests[0]
        case 2:
            cell.movie1.text = interests[0]
            cell.movie2.text = interests[1]
        case 3:
            cell.movie1.text = interests[0]
            cell.movie2.text = interests[1]
            cell.item1.text = interests[2]
        case 4:
            cell.movie1.text = interests[0]
            cell.movie2.text = interests[1]
            cell.item1.text = interests[2]
            cell.item2.text = interests[3]
        default:
            cell.movie1.text = ""
            cell.movie2.text = ""
            cell.item1.text = ""
            cell.item2.text = ""
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: Send user to donation page
        chosenChild = childrenArray[indexPath.row]
        print(chosenChild!.getName())
        if(tableView.isEditing == false){
            self.performSegue(withIdentifier: "toDonate", sender: self)
        }
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if(type == "admin"){
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            completion(true)
            print("Edit Tapped")
            self.chosenChild = self.childrenArray[indexPath.row]
            self.performSegue(withIdentifier: "toEdit", sender: self)
        }
        edit.backgroundColor = .systemBlue
        
        let delete = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            completion(true)
            print("Delete Tapped")
            self.chosenChild = self.childrenArray[indexPath.row]
            self.alertUser(passedIndex: indexPath.row)
        }
        delete.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [edit, delete])
        config.performsFirstActionWithFullSwipe = false
        
        return config
        } else{
            return nil
        }
    }
    
    func alertUser(passedIndex: Int){
        print("Alert Presented")
        let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete \(chosenChild!.getName()) from the list?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { action in
            self.getDocID()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getDocID(){
        var docID = ""
        let id = Double(chosenChild!.getID())
        let db = Firestore.firestore()
        
        db.collection("children").whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        docID = document.documentID.description
                        print("DOC ID: \(docID)")
                        self.deleteChild(docID: docID)
                    }
                }
            }
        
       
    }
    
    func deleteChild(docID: String){
        let db = Firestore.firestore()
        db.collection("children").document(docID).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                self.getChildrenFromDB()
            }
        }
    
    }
    
    //Prepare for segue to pass data.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDonate" {
            if let donateToChild = segue.destination as? DonateAmountVC {
                donateToChild.selectedChild = chosenChild
            }
        } else if segue.identifier == "toEdit"{
            if let editChild = segue.destination as? EditChildVC {
                editChild.passedChild = chosenChild
            }
        }
    }
}



