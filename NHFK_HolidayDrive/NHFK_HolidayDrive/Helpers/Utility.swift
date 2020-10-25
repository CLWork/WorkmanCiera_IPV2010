//
//  Utility.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/25/20.
//

import Foundation
public class Utility{
    
    //Ensures entered email matches appropriate format.
    public static func checkEmailFormat(_ email: String) -> Bool {
        let emailRegEx = "(?:[a-zA-Z0-9!#$%\\&‘*+/=?\\^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let testEmail = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return testEmail.evaluate(with: email)
    }
    
    //Ensures password meets strength requirements.
    public static func checkPasswordStrength(p: String) -> Bool{
        let passRegex = "^(?=.*[a-z])(?=.*[$@$#!%*?&])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        
        let testP = NSPredicate(format: "SELF MATCHES %@", passRegex)
        return testP.evaluate(with: p)
    }
    
    public static func comparePass(p: String, p2: String)-> Bool{
        if(p == p2){
            return true
        } else{
            return false
        }
    }
}
