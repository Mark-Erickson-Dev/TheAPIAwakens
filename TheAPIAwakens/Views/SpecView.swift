//
//  SpecView.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 1/2/19.
//  Copyright © 2019 Mark Erickson. All rights reserved.
//

import UIKit

class SpecView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!

    var isMeters: Bool = true
    var isCredits: Bool = true
    var rate: Double = 0.0
    
    var parentVC: UIViewController!
    
    var vehicle: Vehicle? {
        didSet {
            configureViewForVehicle()
        }
    }
    
    var starship: Starship? {
        didSet {
            configureViewForStarship()
        }
    }
    
    // Configures the view for a vehicle entity type, setting all labels.
    func configureViewForVehicle() {
        if let vehicle = vehicle {
            nameLabel.text = vehicle.name
            makeLabel.text = vehicle.manufacturer
            costLabel.text = makeCost(from: vehicle.costInCredits)
            lengthLabel.text = makeMeasurement(from: vehicle.length)
            classLabel.text = vehicle.vehicleClass
            crewLabel.text = vehicle.crew

        }
    }
    
    // Configures the view for a starship entity type, setting all labels.
    func configureViewForStarship() {
        if let starship = starship {
            nameLabel.text = starship.name
            makeLabel.text = starship.manufacturer
            costLabel.text = makeCost(from: starship.costInCredits)
            lengthLabel.text = makeMeasurement(from: starship.length)
            classLabel.text = starship.starshipClass
            crewLabel.text = starship.crew
        }
    }
    
    // Takes a measurement value as a string, converts it to a Double to perform arithmetic operations, and then returns it as a string for a label.
    // Commas are removed from strings so they can be converted to Doubles.
    func makeMeasurement(from measurementAsString: String) -> String {
        
        guard measurementAsString != "unknown" else {
            return "unknown"
        }
        
        let cleanString = measurementAsString.replacingOccurrences(of: ",", with: "")
        
        if let measurement = Double(cleanString) {
            if isMeters == false {
                let convertedMeasurement = (measurement * 39.370079)
                let formattedMeasurement = String(format: "%.2f", convertedMeasurement)
                return "\(formattedMeasurement)in"
            } else {
                return "\(measurement)m"
            }
        } else {
            return ""
        }
    }
    
    // Takes a cost value as a string, converts it to a Double to perform arithmetic operations, and then returns it as a string for a label.
    func makeCost(from costAsString: String) -> String {
        
        guard costAsString != "unknown" else {
            return "unknown"
        }
        
        if isCredits == false {
            if let cost = Double(costAsString) {
                let convertedCost = cost * rate
                let roundedCost = String(format: "%.2f", convertedCost)
                return "$\(roundedCost)"
            } else {
                return ""
            }
        } else {
            return costAsString
        }
    }
    
    // Sets the measurement buttons to the correct color, according to the bool isMeters.
    // lengthLabel is set to display the cost value according to the unit designated (meters or inches).
    @IBAction func toggleMeasurementUnit() {
        isMeters.toggle()
        
        if isMeters {
            englishButton.setTitleColor(.gray, for: .normal)
            metricButton.setTitleColor(.white, for: .normal)
        } else {
            metricButton.setTitleColor(.gray, for: .normal)
            englishButton.setTitleColor(.white, for: .normal)
        }
        
        if let vehicle = vehicle {
            lengthLabel.text = makeMeasurement(from: vehicle.length)
        }
        
        if let starship = starship {
            lengthLabel.text = makeMeasurement(from: starship.length)
        }
    }
    
    // Presents an alertView asking the user to input an exchange rate value.
    // After an appropriate rate value is attained, toggleMonetaryUnit is called to display the cost in US dollars.
    @IBAction func usdButtonTapped(_ sender: Any) {
        let alert = Alert()
        alert.showRateAlert(vc: self.parentVC) { result in
            self.rate = result
            DispatchQueue.main.async {
                self.toggleMonetaryUnit()
            }
        }
    }
    
    // Calls the toggleMonetaryUnit function to display the entity cost in credits.
    @IBAction func creditsButtonTapped(_ sender: Any) {
        toggleMonetaryUnit()
    }
    
    // Sets the monetary buttons to the correct color, according to the bool isCredits.
    // setCostLabel is called to display the cost value according, to the unit designated (credits or US dollars).
    func toggleMonetaryUnit() {
        isCredits.toggle()
        
        if isCredits {
            usdButton.setTitleColor(UIColor.gray, for: .normal)
            creditsButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.creditsButton.setTitleColor(UIColor.gray, for: .normal)
            self.usdButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        if let vehicle = vehicle {
            costLabel.text = makeCost(from: vehicle.costInCredits)
        }
        
        if let starship = starship {
            costLabel.text = makeCost(from: starship.costInCredits)
        }
    }
}
