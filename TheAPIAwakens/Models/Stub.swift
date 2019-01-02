//
//  Stub.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/19/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

struct Stub {
    
    static var dummyCharacter: Character {
        return Character(name: "", birthYear: "", homeworld: "", length: "", eyeColor: "", hairColor: "", vehicles: [], starships: [])
    }

    static var dummyCharacters: [Character] = [Stub.dummyCharacter]

    static var character: Character {
        return Character(name: "Luke Skywalker", birthYear: "19BBY", homeworld: "https://swapi.co/api/planets/1/", length: "172", eyeColor: "blue", hairColor: "blond", vehicles: ["https://swapi.co/api/vehicles/14/", "https://swapi.co/api/vehicles/30/"], starships: ["https://swapi.co/api/starships/12/", "https://swapi.co/api/starships/22/"])
    }

    static var characters: [Character] = [

        Character(name: "Han Solo", birthYear: "29BBY", homeworld: "https://swapi.co/api/planets/22/", length: "180", eyeColor: "brown", hairColor: "brown", vehicles: [], starships: ["https://swapi.co/api/starships/10/", "https://swapi.co/api/starships/22/"]),

        Character(name: "Luke Skywalker", birthYear: "19BBY", homeworld: "https://swapi.co/api/planets/1/", length: "172", eyeColor: "blue", hairColor: "blond", vehicles: ["https://swapi.co/api/vehicles/14/", "https://swapi.co/api/vehicles/30/"], starships: ["https://swapi.co/api/starships/12/", "https://swapi.co/api/starships/22/"]),

        Character(name: "Leia Organa", birthYear: "19BBY", homeworld: "https://swapi.co/api/planets/2/", length: "150", eyeColor: "brown", hairColor: "brown", vehicles: ["https://swapi.co/api/vehicles/30/"], starships: []),
        ]
    
    static var dummyVehicle: Vehicle {
        return Vehicle(name: "", manufacturer: "", costInCredits: "", length: "", vehicleClass: "", crew: "")
    }
    
    static var dummyVehicles: [Vehicle] = [Stub.dummyVehicle]
    
    static var vehicle: Vehicle {
        return Vehicle(name: "Sand Crawler", manufacturer: "Corelia Mining Corporation", costInCredits: "150000", length: "36.8", vehicleClass: "Wheeled", crew: "46")
    }
    
    static var vehicles: [Vehicle] = [
        
        Vehicle(name: "Snowspeeder", manufacturer: "Incom corporation", costInCredits: "unknown", length: "4.5", vehicleClass: "airspeeder", crew: "2"),
        
        Vehicle(name: "TIE Bomber", manufacturer: "Sienar Fleet Systems", costInCredits: "unknown", length: "7.8", vehicleClass: "space/planetary bomber", crew: "1"),
        
        Vehicle(name: "Sand Crawler", manufacturer: "Corelia Mining Corporation", costInCredits: "150000", length: "36.8", vehicleClass: "Wheeled", crew: "46")
    ]
    
    static var dummyStarship: Starship {
        return Starship(name: "", manufacturer: "", costInCredits: "", length: "", starshipClass: "", crew: "")
    }
    
    static var dummyStarships: [Starship] = [Stub.dummyStarship]
    
    static var starship: Starship {
        return Starship(name: "Millennium Falcon", manufacturer: "Corellian Engineering Corporation", costInCredits: "100000", length: "34.37", starshipClass: "Light freighter", crew: "4")
    }
    
    static var starships: [Starship] = [
        
        Starship(name: "Millennium Falcon", manufacturer: "Corellian Engineering Corporation", costInCredits: "100000", length: "34.37", starshipClass: "Light freighter", crew: "4"),
        
        Starship(name: "Slave 1", manufacturer: "Kuat Systems Engineering", costInCredits: "unknown", length: "21.5", starshipClass: "Patrol craft", crew: "1"),
        
        Starship(name: "X-wing", manufacturer: "Incom Corporation", costInCredits: "149999", length: "12.5", starshipClass: "Starfighter", crew: "1")
    ]
}
