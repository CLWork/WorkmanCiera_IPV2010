//
//  Users.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/24/20.
//

import Foundation

public class Users: Codable {
    
    //Member variables
    private var fullName: String = ""
    private var email: String = ""
    private var address: String = ""
    private var type: String = ""
    
    //Constructor
    init(fName: String, userEmail: String){
        fullName = fName
        email = userEmail
    }
    
    //Getters
    public func getFName()-> String{
        return fullName
    }
    public func getEmail()-> String{
        return email
    }
    public func getAddress()-> String{
        return address
    }
    public func getType()->String{
        return type;
    }
    
    //Setters
    public func setFName(n: String){
        fullName = n
    }
    public func setEmail(e: String){
        email = e
    }
    public func setAddress(a:String){
        address = a
    }
    public func setType(t: String){
        type = t
    }
}
