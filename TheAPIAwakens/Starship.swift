//
//  Starship.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

class Starship: Vehicle {
    
//    let name: String
//    let manufacturer: String
//    let costInCredits: Int?
//    let length: Double
//    let vehicleClass: String
//    let crew: Int
    
    override init(name: String, manufacturer: String, costInCredits: Int?, length: Double, vehicleClass: String, crew: Int) {
//        self.name = name
//        self.manufacturer = manufacturer
//        self.costInCredits = costInCredits
//        self.length = length
//        self.vehicleClass = vehicleClass
//        self.crew = crew
        super.init(name: name, manufacturer: manufacturer, costInCredits: costInCredits, length: length, vehicleClass: vehicleClass, crew: crew)
        self.icon = #imageLiteral(resourceName: "icon-starships")
        self.type = .starship
    }
}
