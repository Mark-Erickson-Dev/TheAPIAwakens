//
//  Vehicle.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

class Vehicle: SWEntity {
    
    let name: String
    let manufacturer: String
    let costInCredits: Int?
    let length: Double
    let vehicleClass: String
    let crew: Int
    var icon:UIImage = #imageLiteral(resourceName: "icon-vehicles")
    var type:SWEntityType = .vehicle
    
    init(name: String, manufacturer: String, costInCredits: Int?, length: Double, vehicleClass: String, crew: Int) {
        self.name = name
        self.manufacturer = manufacturer
        self.costInCredits = costInCredits
        self.length = length
        self.vehicleClass = vehicleClass
        self.crew = crew
    }
}
