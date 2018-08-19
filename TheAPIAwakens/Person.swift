//
//  Person.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

class Person {
    let name: String
    let birthYear: String
    let homeworld: String
    let height: Double
    let eyeColor: String
    let hairColor: String
    
    init(name: String, birthYear: String, homeworld: String, height: Double, eyeColor: String, hairColor: String) {
        self.name = name
        self.birthYear = birthYear
        self.homeworld = homeworld
        self.height = height
        self.eyeColor = eyeColor
        self.hairColor = hairColor
    }
}
