//
//  Alert.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 12/19/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

class Alert {
    
    var rate: Double = 0.0
    typealias CompletionHandler = (Double) -> Void
    
    class func showErrorAlert(title: String, message: String, vc: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func showRateAlert(vc: UIViewController, completion: @escaping CompletionHandler) {
    
        let alertController = UIAlertController(title: "Credit Conversion", message: "Enter an exchange rate", preferredStyle: .alert)
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.text = "\(0.0)"
        })

        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let textField = alertController.textFields![0] as UITextField
            //print("Text field: \(textField.text)")
            guard let text = textField.text, let rateAsDouble = Double(text) else {
                Alert.showErrorAlert(title: "Data Error", message: SwapiError.invalidRate.description, vc: vc)
                return
            }
            do {
                let rateHere = try self.validateRate(rate: rateAsDouble)
                self.rate = rateHere
                completion(self.rate)
                
            } catch SwapiError.invalidRate {
                Alert.showErrorAlert(title: "Data Error", message: SwapiError.invalidRate.description, vc: vc)
                return
                
            } catch let error {
                print(error)
            }
        }))
        vc.present(alertController, animated: true, completion: nil)
    }
    
    func validateRate(rate: Double) throws -> Double {
        guard rate > 0 else {
            
            throw SwapiError.invalidRate
        }
        return rate
    }
}
