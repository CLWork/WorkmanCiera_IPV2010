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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkType()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getChildrenFromDB()
    }
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
    
    func getChildrenFromDB(){
        
        db.collection("children").getDocuments { (snapshot, error ) in
            
            if(error != nil){
                print(error!.localizedDescription)
            } else{
                
                for document in snapshot!.documents{
                    
                    
                    let id = document.get("id") as? Int
                    let name = document.get("name") as? String
                    let age = document.get("age") as? Int
                    let program = document.get("program") as? String
                    let movieArray = document.get("movies") as? [String]
                    let itemArray = document.get("items") as? [String]
                    
                    
                    if(name != nil){
                        self.showToast(message: "Child Added From DB: \(name!)")
                        let interestArray = [movieArray?[0], itemArray?[0], itemArray?[1]]
                        
                        let supportedChild = Child(id: id ?? 0, name: name!, age: age ?? 0, program: program!, interests: interestArray)
                        self.childrenArray.append(supportedChild)
                        print(self.childrenArray.count.description)
                    }
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return childrenArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "child_cell", for: indexPath) as? ChildCell else {return tableView.dequeueReusableCell(withIdentifier: "child_cell", for: indexPath) }
        
        cell.childNameAge.text = childrenArray[indexPath.row].getName() + ", " + childrenArray[indexPath.row].getAge().description
        cell.program.text = childrenArray[indexPath.row].getProgram()
        
        let interests = childrenArray[indexPath.row].getInterests()
        
        cell.movie1.text = interests[0]
        cell.item1.text = interests[1]
        cell.item2.text = interests[2]
        
        return cell
    }
    
    
}
