//
//  Error.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 12/17/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import Foundation

enum DataError: Error {
    
    case InvalidRate
    
    var description: String {
        
        switch self {
        case .InvalidRate: return "Exchange rate must be a positive number."

        }
    }
}
