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
    private var addressLineOne: String = ""
    private var addressLineTwo: String = ""
    private var city: String = ""
    private var state: String = ""
    private var zipcode: Int = 0
    private var type: String = ""
    private var donationHistory = [String: Double]()
    //Constructor
    init(fName: String, userEmail: String){
        fullName = fName
        email = userEmail
    }
    
    func getUserDic()->[String: Any]{
        
        let dic = [
            "fullName": self.fullName,
            "email": self.email,
            "type": self.type,
            "addressLineOne": self.addressLineOne,
            "addressLineTwo": self.addressLineTwo,
            "city": self.city,
            "state": state,
            "zipcode": zipcode,
            "history": donationHistory] as [String: Any]
        
        return dic
        
    }
    
    //Getters
    public func getFName()-> String{
        return fullName
    }
    public func getEmail()-> String{
        return email
    }
    public func getAddressLineOne()-> String{
        return addressLineOne
    }
    public func getAddressLineTwo()-> String{
        return addressLineTwo
    }
    public func getCity()->String{
        return city
    }
    public func getState()->String{
        return state
    }
    public func getZipcode()->Int{
        return zipcode
    }
    public func getType()->String{
        return type;
    }
    
    public func getHistory()->[String: Double]{
        return donationHistory
    }
    
    //Setters
    public func setFName(n: String){
        fullName = n
    }
    public func setEmail(e: String){
        email = e
    }
    public func setAddressLineOne(a1:String){
        addressLineOne = a1
    }
    public func setAddressLineTwo(a2:String){
        addressLineTwo = a2
    }
    public func setCity(c:String){
        city = c
    }
    public func setState(s:String){
        state = s
    }
    public func setZipcode(z:Int){
        zipcode = z
    }
    public func setType(t: String){
        type = t
    }
    public func setHistory(h: [String: Double]){
        donationHistory = h
    }
}
