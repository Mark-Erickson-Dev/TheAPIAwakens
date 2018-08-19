//
//  Entity.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

struct Entity {
    let image:UIImage
    let name: String
}

struct EntityData {
    static let entities = [
        Entity(image: #imageLiteral(resourceName: "icon-characters"), name: "Characters"),
        Entity(image: #imageLiteral(resourceName: "icon-vehicles"), name: "Vehicles"),
        Entity(image: #imageLiteral(resourceName: "icon-starships"), name: "Starships")
    ]
}
