//
//  SWEntity.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

protocol SWEntity: Codable, Measureable {
    //var type: SWEntityType { get }
    var name: String { get }
}

protocol Measureable {
    var length: String { get }
}

//protocol Results: Codable {
//    var results: [BS] {get}
//}

//struct Results {
//    let results: [BS]
//}

enum SWEntityType: String {
    case characters = "Characters"
    case vehicles = "Vehicles"
    case starships = "Starships"
    
    var description: String {
        switch self {
        case .characters: return "/api/people/?page="
        case .vehicles: return "/api/vehicles/?page="
        case .starships: return "/api/starships/?page="
        }
    }
}

//class SWEntity: Codable {
//
//    let type: SWEntityType
//
//    init(type: SWEntityType) {
//        self.type = type
//    }
//
//    required init(from: Decoder) {
//
//    }
//
//    func encode(to encoder: Encoder) throws {
//    }
//}

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
    
        MainMenuItem(icon: #imageLiteral(resourceName: "icon-characters"), type: .characters),
        MainMenuItem(icon: #imageLiteral(resourceName: "icon-vehicles"), type: .vehicles),
        MainMenuItem(icon: #imageLiteral(resourceName: "icon-starships"), type: .starships)
    ]
}

