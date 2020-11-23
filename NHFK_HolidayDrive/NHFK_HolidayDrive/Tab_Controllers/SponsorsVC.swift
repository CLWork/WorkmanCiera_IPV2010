//
//  SponsorsVC.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/23/20.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

let cellID = "sponsor_cell"
class SponsorsVC: UITableViewController{
    
    @IBOutlet weak var navBar: UINavigationBar!
    var type = ""
    
    var sponsorArray = [Sponsor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        checkType()
    }
    
    //determine if user can see bar button items
    func checkType(){
        let db = Firestore.firestore()
        let currentUser = Auth.auth().currentUser
        db.collection("users").document(currentUser!.uid)
            .getDocument { (snapshot, error ) in
                
                if let document = snapshot {
                    self.type = document.get("type") as? String ?? "user"
                    if(self.type == "admin"){
                        self.navBar.isHidden = false
                        
                    } else{
                        self.navBar.isHidden = true
                    }
                    
                    self.getSponsorFromDB()
                    
                } else {
                    
                    print("User does not exist. This should not happen.")
                    
                }
            }
    }
    
    
    func getSponsorFromDB(){
        let db = Firestore.firestore()
        db.collection("sponsors").getDocuments { (snapshot, error) in
            guard error == nil else{
                return
            }
            for document in snapshot!.documents{
                print(snapshot?.documents.count.description ?? "Not FOUND")
                
                let name = document.get("name") as? String
                let website = document.get("website") as? String
                
                if(name != nil){
                    let foundSponsor = Sponsor(name: name!, website: website!)
                    self.sponsorArray.append(foundSponsor)
                    self.tableView.reloadData()
                }
            }
            
        }
        
    }
    
    func getSponsorImage(){
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sponsorArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? SponsorCell else {return tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) }
        
        cell.name?.text = sponsorArray[indexPath.row].getName()
        
        return cell
    }
    
}
