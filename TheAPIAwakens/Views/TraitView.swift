//
//  TraitView.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 1/2/19.
//  Copyright © 2019 Mark Erickson. All rights reserved.
//

import UIKit

class TraitView: UIView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var eyesLabel: UILabel!
    @IBOutlet weak var hairLabel: UILabel!
    
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    
    @IBOutlet weak var starshipTextView: UITextView!
    @IBOutlet weak var vehicleTextView: UITextView!
    
    var isMeters: Bool = true
    let client = SwapiClient()
    
    var character: Character? {
        didSet {
            configureViewForCharacter()
        }
    }
    
    // Configures the view for a character entity type, setting all labels and textviews.
    func configureViewForCharacter() {
        if let character = character {
            nameLabel.text = character.name
            bornLabel.text = character.birthYear
            setPlanetLabel(from: character.homeworld)
            setTextView(for: vehicleTextView, from: character.vehicles, type: Vehicle.self, defaultString: SWEntityType.vehicles.description)
            setTextView(for: starshipTextView, from: character.starships, type: Starship.self, defaultString: SWEntityType.starships.description)
            heightLabel.text = makeMeasurement(from: character.length)
            eyesLabel.text = character.eyeColor
            hairLabel.text = character.hairColor
        }
    }
    
    // Makes a request to the Swapi API that retrieves a planet.
    // On the main thread: The planet label is set according to the planet's name.
    func setPlanetLabel(from urlString: String) {
        client.getData(for: urlString) { (result: Planet?, error) in
            if let planet = result {
                DispatchQueue.main.async {
                    self.homeLabel.text = planet.name
                }
            }
        }
    }
    
    // Makes a request to the Swapi API that retrieves an entity type. The type is determined when the function is called.
    // On the main thread: The entities returned, if any, are appended to an array and then dispalyed in a textview.
    func setTextView<T: SWEntity>(for textView: UITextView, from array: [String], type: T.Type, defaultString: String) {
        textView.text = ""
        if array.isEmpty {
            textView.text += "No Associated \(defaultString)."
        } else {
            var names = [String]()
            for urlString in array {
                client.getData(for: urlString) { (result: T?, error) in
                    if let entity = result {
                        DispatchQueue.main.async {
                            names.append(entity.name)
                            let joinedString = names.joined(separator: ", ")
                            textView.text = "Associated \(defaultString): " + joinedString
                        }
                    }
                }
            }
        }
    }
    
    // Takes a measurement value as a string, converts it to a Double to perform arithmetic operations, and then returns it as a string for a label.
    // Commas are removed from strings so they can be converted to Doubles.
    // Character measurements are divided by 100 to convert centimeters to meters.
    func makeMeasurement(from measurementAsString: String) -> String {
        
        guard measurementAsString != "unknown" else {
            return "unknown"
        }
        
        let cleanString = measurementAsString.replacingOccurrences(of: ",", with: "")
        
        if let measurement = Double(cleanString) {
            if isMeters == false {
                let convertedMeasurement = (measurement * 39.370079) / 100
                let formattedMeasurement = String(format: "%.2f", convertedMeasurement)
                return "\(formattedMeasurement)in"
            } else {
                return "\(measurement/100)m"
            }
        } else {
            return ""
        }
    }
    
    // Sets the measurement buttons to the correct color, according to the bool isMeters.
    // heightLabel is set to display the cost value according to the unit designated (meters or inches).
    @IBAction func toggleMeasurementUnit() {
        isMeters.toggle()
        
        if isMeters {
            englishButton.setTitleColor(.gray, for: .normal)
            metricButton.setTitleColor(.white, for: .normal)
        } else {
            metricButton.setTitleColor(.gray, for: .normal)
            englishButton.setTitleColor(.white, for: .normal)
        }
        
        if let character = character {
            heightLabel.text = makeMeasurement(from: character.length)
        }
    }
    
}
