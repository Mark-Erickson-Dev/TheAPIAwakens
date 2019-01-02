//
//  SwapiError.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 12/17/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

enum SwapiError: Error {
    
    case invalidRate, requestFailed, responseUnsuccesful(statusCode: Int), invalidData, jsonParsingFailure, invalidUrl
    
    var description: String {

        switch self {
        case .invalidRate: return "Exchange rate must be a positive number."
        case .requestFailed: return "Request failed."
        case .responseUnsuccesful(let statusCode): return "Usuccessful response, status code: \(statusCode)."
        case .invalidData: return "No data received. Device offline."
        case .jsonParsingFailure: return "Failed to parse the JSON data."
        case .invalidUrl: return "Invalid URL."
        }
    }
}
