//
//  Child.swift
//  NHFK_HolidayDrive
//
//  Created by Ciera on 10/29/20.
//

import Foundation

class Child {
    
    //Member variables
    private var id: Int
    private var name: String
    private var program: String
    private var age: Int
    private var interests: [String?]
    
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
    
    
}
