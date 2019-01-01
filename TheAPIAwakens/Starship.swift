//
//  Starship.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

struct Starship: SWEntity, Codable, Measureable {
    let name: String
    let manufacturer: String
    let costInCredits: String
    let length: String
    let starshipClass: String
    let crew: String
    
    let type: SWEntityType = .starships
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case manufacturer = "manufacturer"
        case costInCredits = "cost_in_credits"
        case length = "length"
        case starshipClass = "starship_class"
        case crew = "crew"
    }
}

struct StarshipResults: Codable {
    let starships: [Starship]
    let next: String?
    let count: Int
    
    private enum CodingKeys: String, CodingKey {
        case starships = "results"
        case next = "next"
        case count = "count"
    }
}

struct Planet: SWEntity, Codable {
    let name: String
    let length: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case length = "diameter"
    }
}

//class Starship: Vehicle {
//
////    let name: String
////    let manufacturer: String
////    let costInCredits: Int?
////    let length: Double
////    let vehicleClass: String
////    let crew: Int
//
//    override init(name: String, manufacturer: String, costInCredits: String, length: String, vehicleClass: String, crew: String) {
////        self.name = name
////        self.manufacturer = manufacturer
////        self.costInCredits = costInCredits
////        self.length = length
////        self.vehicleClass = vehicleClass
////        self.crew = crew
//        super.init(name: name, manufacturer: manufacturer, costInCredits: costInCredits, length: length, vehicleClass: vehicleClass, crew: crew)
//        //self.icon = #imageLiteral(resourceName: "icon-starships")
//        self.type = .starship
//    }
//
//    required init(from decoder: Decoder) throws {
//        fatalError("init(from:) has not been implemented")
//    }
//}
