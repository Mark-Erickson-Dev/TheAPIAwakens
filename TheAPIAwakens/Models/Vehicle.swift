//
//  Vehicle.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

struct Vehicle: SWEntity, Codable, Measureable {
    let name: String
    let manufacturer: String
    let costInCredits: String
    let length: String
    let vehicleClass: String
    let crew: String
    
    let type: SWEntityType = .vehicles
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case manufacturer = "manufacturer"
        case costInCredits = "cost_in_credits"
        case length = "length"
        case vehicleClass = "vehicle_class"
        case crew = "crew"
    }
}

struct VehicleResults: Codable {
    let vehicles: [Vehicle]
    let next: String?
    let count: Int
    
    private enum CodingKeys: String, CodingKey {
        case vehicles = "results"
        case next = "next"
        case count = "count"
    }
}
