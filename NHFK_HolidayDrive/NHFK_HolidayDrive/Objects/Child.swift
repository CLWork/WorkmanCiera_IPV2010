//
//  Child.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/29/20.
//

import Foundation

class Child{
    
    //Member variables
    private var id: Int
    private var name: String
    private var program: String
    private var age: Int
    private var interests: [String?]
    private var hidden: Bool = false
    private var cap: Int = 100
    private var total: Int = 0
    private var donors: [String: Int]?
    private var counter = 0
    
    //Constructor
    init(id: Int, name: String, age: Int, program: String, interests: [String?]){
        self.id = id
        self.name = name
        self.age = age
        self.program = program
        self.interests = interests
    }
    
    //Getters
    public func getName()-> String{
        return name
    }
    
    public func getAge() -> Int{
        return age
    }
    
    public func getProgram()-> String{
        return program
    }
    
    public func getInterests()-> [String?]{
        return interests
    }
    
    public func getHidden()-> Bool{
        return hidden
    }
    public func setHidden(isHidden: Bool){
        hidden = isHidden
    }
    
    public func setCap(cap: Int){
        self.cap = cap
    }
    
    public func getCap()-> Int{
        return cap
    }
    
    public func compareTotal(){
        if(total >= cap){
            hidden = true
        }
    }
    
    public func addDonor(uid: String, amount: Int){
        if donors![uid] != nil{
            let currentValue = donors![uid]
            donors![uid] = currentValue! + amount
        } else{
            donors![uid] = amount
        }
    }
    
    func getChildDic()->[String: Any]{
        
        let dic = [
            "id": id,
            "name": name,
            "age": age,
            "program": program,
            "hidden": hidden,
            "cap": cap,
            "total": total,
            "items":interests ] as [String : Any]
        
        return dic
        
    }
    
    
}
