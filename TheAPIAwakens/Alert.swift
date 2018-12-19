//
//  Alert.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 12/19/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

// Creates an a alert to present a message when an error is thrown
class Alert {
    
    var rate: Double = 0.0
    
    class func showErrorAlert(title: String, message: String, vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        vc.present(alertController, animated: true, completion: nil)
    }
}
