//
//  Entity.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

enum SWEntityType: String {
    case character = "Characters"
    case vehicle = "Vehicles"
    case starship = "Starships"
}

protocol SWEntity {
    var icon: UIImage { get }
    var type: SWEntityType { get }
}

//class SWEntity {
//
//    let icon: UIImage
//    let type: SWEntityType
//    
//    init(icon: UIImage, type: SWEntityType) {
//        self.icon = icon
//        self.type = type
//    }
//}

//struct SWEntityData {
//    static let entities = [
//        SWEntity(icon: #imageLiteral(resourceName: "icon-characters"), type: .character),
//        SWEntity(icon: #imageLiteral(resourceName: "icon-vehicles"), type: .vehicle),
//        SWEntity(icon: #imageLiteral(resourceName: "icon-starships"), type: .starship)
//    ]
//}

//struct SWEntityData {
//    static let entities:[SWEntityType] = [.character, .vehicle, .starship]
//}

struct MainMenuItem {
    
    let icon: UIImage
    let type: SWEntityType
    
    init(icon: UIImage, type: SWEntityType) {
        self.icon = icon
        self.type = type
    }
}

struct MainMenuData {
    
    static let mainMenuEntities: [MainMenuItem] = [
    
        MainMenuItem(icon: #imageLiteral(resourceName: "icon-characters"), type: .character),
        MainMenuItem(icon: #imageLiteral(resourceName: "icon-vehicles"), type: .vehicle),
        MainMenuItem(icon: #imageLiteral(resourceName: "icon-starships"), type: .starship)
    ]
}

