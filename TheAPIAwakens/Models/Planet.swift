//
//  Planet.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 1/1/19.
//  Copyright © 2019 Mark Erickson. All rights reserved.
//

import Foundation

struct Planet: SWEntity, Codable {
    let name: String
    let length: String
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case length = "diameter"
    }
}
