//
//  CharacterViewModel.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 12/21/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

struct CharacterViewModel {
    let name: String
    let birthYear: String
    let homeworld: String
    let length: String
    let eyeColor: String
    let hairColor: String
    let vehicles: [String]
    let starships: [String]
    
    init(model: Character) {
        self.name = model.name
        self.birthYear = model.birthYear
        self.homeworld = model.homeworld
        self.length = model.length
        self.eyeColor = model.eyeColor
        self.hairColor = model.hairColor
        self.vehicles = model.vehicles
        self.starships = model.starships
    }
}
