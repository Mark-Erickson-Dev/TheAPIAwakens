//
//  Endpoint.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 12/19/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

enum Resource: String {
    
    case people, vehicles, starships
    
    var description: String {
        
        switch self {
        case .people: return "/people"
        case .vehicles: return "/vehicles"
        case .starships: return "/starships"
        }
    }
}

protocol Endpoint {
    var base: String { get }
    var path: String { get }
    var resource: String { get }
}

extension Endpoint {
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path + resource
    
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}

enum Swapi {
    case searchPeople
    case searchVehicles
    case searchStarships
}

extension Swapi: Endpoint {
    
    var base: String {
        return "https://swapi.co"
    }
    
    var path: String {
        return "/api"
    }
    
    var resource: String {
        switch self {
        case .searchPeople:
            return Resource.people.description
        case .searchVehicles:
            return Resource.vehicles.description
        case .searchStarships:
            return Resource.starships.description
        }
    }
}
