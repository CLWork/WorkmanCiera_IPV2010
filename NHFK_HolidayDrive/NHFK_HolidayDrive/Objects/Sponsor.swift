//
//  Sponsor.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/29/20.
//

import Foundation

class Sponsor{
    var name: String
    var website: String
    
    init(name: String, website: String){
        self.name = name
        self.website = website
    }
    
    public func getName()-> String{
        return name
    }
    
    public func getWebsite()->String{
        return website
    }
    
    public func setName(n: String){
        self.name = n
    }
    
    public func setWebsite(w:String){
        self.website = w
    }
}
