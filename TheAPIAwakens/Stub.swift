//
//  Stub.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/19/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

struct Stub {
    
    static var character: Character {
        return Character(name: "Luke Skywalker", birthYear: "19BBY", homeworld: "Tatooine", height: 1.72, eyeColor: "Blue", hairColor: "Blond")
    }
    
    static var characters: [Character] = [
    
        Character(name: "Han Solo", birthYear: "20BBY", homeworld: "Someplace", height: 1.88, eyeColor: "Brown", hairColor: "Brown"),
        
        Character(name: "Luke Skywalker", birthYear: "19BBY", homeworld: "Tatooine", height: 1.72, eyeColor: "Blue", hairColor: "Blond"),
        
        Character(name: "Leia Organa", birthYear: "19BBY", homeworld: "Tatooine", height: 1.53, eyeColor: "Brown", hairColor: "Brown"),
    ]
    
    static var vehicle: Vehicle {
        return Vehicle(name: "Sand Crawler", manufacturer: "Corelia Mining Corporation", costInCredits: 150000, length: 36.8, vehicleClass: "Wheeled", crew: 46)
    }
    
    static var vehicles: [Vehicle] = [
    
        Vehicle(name: "Snowspeeder", manufacturer: "Incom corporation", costInCredits: nil, length: 4.5, vehicleClass: "airspeeder", crew: 2),
        
        Vehicle(name: "TIE Bomber", manufacturer: "Sienar Fleet Systems", costInCredits: nil, length: 7.8, vehicleClass: "space/planetary bomber", crew: 1),
        
        Vehicle(name: "Sand Crawler", manufacturer: "Corelia Mining Corporation", costInCredits: 150000, length: 36.8, vehicleClass: "Wheeled", crew: 46)
    ]
    
    static var starship: Starship {
        return Starship(name: "Millennium Falcon", manufacturer: "Corellian Engineering Corporation", costInCredits: 100000, length: 34.37, vehicleClass: "Light freighter", crew: 4)
    }
    
    static var starships: [Starship] = [
    
        Starship(name: "Millennium Falcon", manufacturer: "Corellian Engineering Corporation", costInCredits: 100000, length: 34.37, vehicleClass: "Light freighter", crew: 4),
        
        Starship(name: "Slave 1", manufacturer: "Kuat Systems Engineering", costInCredits: nil, length: 21.5, vehicleClass: "Patrol craft", crew: 1),
        
        Starship(name: "X-wing", manufacturer: "Incom Corporation", costInCredits: 149999, length: 12.5, vehicleClass: "Starfighter", crew: 1)
    ]
}
