//
//  SWEntity.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

protocol SWEntity: Codable, Measureable {
    var name: String { get }
}

protocol Measureable {
    var length: String { get }
}

enum SWEntityType {
    case characters
    case vehicles
    case starships
    
    var description: String {
        switch self {
        case .characters: return "Characters"
        case .vehicles: return "Vehicles"
        case .starships: return "Starships"
        }
    }
    
    var resource: String {
        switch self {
        case .characters: return "/api/people/?page="
        case .vehicles: return "/api/vehicles/?page="
        case .starships: return "/api/starships/?page="
        }
    }
}


