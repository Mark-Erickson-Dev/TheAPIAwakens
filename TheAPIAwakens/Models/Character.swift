//
//  Character.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

struct Character: SWEntity, Codable, Measureable {
    let name: String
    let birthYear: String
    let homeworld: String
    let length: String
    let eyeColor: String
    let hairColor: String
    let vehicles: [String]
    let starships: [String]
    
    let type: SWEntityType = .characters

    // Example of maually mapped coding keys for the json decoder
    // format: case yourModelProperty = "json_property_from_server"
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case birthYear = "birth_year"
        case homeworld = "homeworld"
        case length = "height"
        case eyeColor = "eye_color"
        case hairColor = "hair_color"
        case vehicles = "vehicles"
        case starships = "starships"
    }
}

struct CharacterResults: Codable {
    let characters: [Character]
    let next: String?
    let count: Int
    
    // "results" is an array of people
    private enum CodingKeys: String, CodingKey {
        case characters = "results"
        case next = "next"
        case count = "count"
    }
}
