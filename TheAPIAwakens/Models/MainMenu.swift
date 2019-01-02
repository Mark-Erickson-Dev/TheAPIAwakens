//
//  MainMenu.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 1/1/19.
//  Copyright © 2019 Mark Erickson. All rights reserved.
//

import UIKit

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
