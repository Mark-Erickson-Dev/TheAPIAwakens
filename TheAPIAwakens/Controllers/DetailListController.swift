//
//  DetailListController.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/19/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

class DetailListController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var eyesLabel: UILabel!
    @IBOutlet weak var hairLabel: UILabel!
    
    @IBOutlet weak var makeLabel: UILabel!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var crewLabel: UILabel!
    
    @IBOutlet var specLabelCollection: [UILabel]!
    @IBOutlet var specValueLabelCollection: [UILabel]!
    @IBOutlet var traitLabelCollection: [UILabel]!
    @IBOutlet var traitValueLabelCollection: [UILabel]!
    @IBOutlet var allButtons: [UIButton]!
    
    @IBOutlet var englishButtons: [UIButton]!
    @IBOutlet var metricButtons: [UIButton]!
    
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var traitView: UIView!
    @IBOutlet weak var specView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var starshipTextView: UITextView!
    @IBOutlet weak var vehicleTextView: UITextView!
    
    var vehicles: [Vehicle]!
    var characters: [Character]!
    var starships: [Starship]!

    var entityCount: Int = 0
    var selectedEntities = [SWEntity]()
    var type: SWEntityType = .characters
    var isMeters: Bool = true
    var isCredits: Bool = true
    var rate: Double = 0.0
    let client = SwapiClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        traitView.isHidden = false
        specView.isHidden = true
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        characters = Stub.dummyCharacters
        vehicles = Stub.dummyVehicles
        starships = Stub.dummyStarships
        
        defaultView()
        getSwapiData()
    }
    
    // Sets up the default values for the view (blank labels). Also disables buttons before the data is returned.
    func defaultView() {
        self.navigationItem.title = type.description
        
        allButtons.forEach({$0.isEnabled = false})
        metricButtons.forEach({$0.setTitleColor(.white, for: .normal)})
        creditsButton.setTitleColor(UIColor.white, for: .normal)

        if type == .characters {
            specView.isHidden = true
            traitView.isHidden = false
        } else {
            traitView.isHidden = true
            specView.isHidden = false
        }
        nameLabel.text = ""
        vehicleTextView.text = ""
        starshipTextView.text = ""
        
        traitValueLabelCollection.forEach({$0.text = ""})
        specValueLabelCollection.forEach({$0.text = ""})

        smallestLabel.text = ""
        largestLabel.text = ""
    }
    
    // Makes a request to the Swapi API and returns an array(results) of Star Wars entities.
    // On the main thread: The view is then configured for an entity and the pickerView is reloaded with all entities of a given type.
    // All buttons are enabled after the data is returned.
    func getSwapiData() {
        activityIndicator.startAnimating()
        client.getData(for: type) { results, error in

            if let results = results {
                self.entityCount = results.count
                switch self.type {
                case .characters:
                    self.characters = results as? [Character]
                case .vehicles:
                    self.vehicles = results as? [Vehicle]
                case .starships:
                    self.starships = results as? [Starship]
                }

                self.configureView()
                self.pickerView.reloadAllComponents()
                self.setSmallestAndLargestLabels(entityArray: results)
                self.allButtons.forEach({$0.isEnabled = true})
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    // Configures the view for an entity type, setting all labels and textviews.
    func configureView() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        
        switch type {
        case .characters:
            let character = characters[selectedRow]
            nameLabel.text = character.name
            bornLabel.text = character.birthYear
            setPlanetLabel(from: character.homeworld)
            setTextView(for: vehicleTextView, from: character.vehicles, type: Vehicle.self, defaultString: SWEntityType.vehicles.description)
            setTextView(for: starshipTextView, from: character.starships, type: Starship.self, defaultString: SWEntityType.starships.description)
            heightLabel.text = makeMeasurement(from: character.length)
            eyesLabel.text = character.eyeColor
            hairLabel.text = character.hairColor
        case .vehicles:
            let vehicle = vehicles[selectedRow]
            nameLabel.text = vehicle.name
            makeLabel.text = vehicle.manufacturer
            costLabel.text = makeCost(from: vehicle.costInCredits)
            lengthLabel.text = makeMeasurement(from: vehicle.length)
            classLabel.text = vehicle.vehicleClass
            crewLabel.text = vehicle.crew
        case .starships:
            let starship = starships[selectedRow]
            nameLabel.text = starship.name
            makeLabel.text = starship.manufacturer
            costLabel.text = makeCost(from: starship.costInCredits)
            lengthLabel.text = makeMeasurement(from: starship.length)
            classLabel.text = starship.starshipClass
            crewLabel.text = starship.crew
        }
    }
    
    // Makes a request to the Swapi API that returns a planet.
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
    
    // Makes a request to the Swapi API that returns an entity type. The type is determined when the function is called.
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
                if type == .characters {
                    let convertedMeasurement = (measurement * 39.370079) / 100
                    let formattedMeasurement = String(format: "%.2f", convertedMeasurement)
                    return "\(formattedMeasurement)in"
                } else {
                    let convertedMeasurement = measurement * 39.370079
                    let formattedMeasurement = String(format: "%.2f", convertedMeasurement)
                    return "\(formattedMeasurement)in"
                }
            } else {
                if type == .characters {
                    
                    return "\(measurement/100)m"
                } else {
                    return "\(cleanString)m"
                }
            }
        } else {
            return ""
        }
    }

    // Takes an array of Star Wars entities and sorts them, according to their length.
    // Values that cannot be converted to Double, such as "unknown", are discarded.
    // Commas are removed from strings so they can be converted to Doubles.
    // The smallestLabel and largestLabel are set to the smallest and largest values of the array.
    func setSmallestAndLargestLabels(entityArray: [SWEntity]) {
        var cleanArray = [(name: String, length: Double)]()
        entityArray.forEach({
            let name = $0.name
            let cleanLength = $0.length.replacingOccurrences(of: ",", with: "")
            
            if let length = Double(cleanLength) {
                cleanArray.append((name, length))
            }
        })
        let sortedArray = cleanArray.sorted(by: {$0.length < $1.length})
        smallestLabel.text = sortedArray.first?.name
        largestLabel.text = sortedArray.last?.name
    }
    
    // Presents an alertView asking the user to input an exchange rate value.
    // After an appropriate rate value is attained, toggleMonetaryUnit is called to display the cost in US dollars.
    @IBAction func usdButtonTapped(_ sender: Any) {
        let alert = Alert()
        alert.showRateAlert(vc: self) { result in
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
        
        setCostLabel()
    }
    
    // Sets the costLabel to the value returned by the makeCost function.
    func setCostLabel() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        if type == .vehicles {
           costLabel.text = makeCost(from: vehicles[selectedRow].costInCredits)
        } else if type == .starships {
            costLabel.text = makeCost(from: starships[selectedRow].costInCredits)
        }
    }
    
    // Sets the measurement buttons to the correct color, according to the bool isMeters.
    // setMeasurementLabel is called to display the cost value according to the unit designated (meters or inches).
    @IBAction func toggleMeasurementUnit() {
        isMeters.toggle()
        
        if isMeters {
            englishButtons.forEach({$0.setTitleColor(.gray, for: .normal)})
            metricButtons.forEach({$0.setTitleColor(.white, for: .normal)})
        } else {
            metricButtons.forEach({$0.setTitleColor(.gray, for: .normal)})
            englishButtons.forEach({$0.setTitleColor(.white, for: .normal)})
        }
        
        setMeasurementLabel()
    }
    
    // Sets the heightLabel/lengthLabel to the value returned by the makeCost function.
    func setMeasurementLabel() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        switch type {
        case .characters:
            heightLabel.text = makeMeasurement(from: characters[selectedRow].length)
        case .vehicles:
            lengthLabel.text = makeMeasurement(from: vehicles[selectedRow].length)
        case .starships:
            lengthLabel.text = makeMeasurement(from: starships[selectedRow].length)
        }
    }
}

extension DetailListController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Tells the pickerView to populate a number of rows equal the count of entites returned from the Swapi API.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return entityCount
    }
    
    // Populates the pickerView with the names of the entities returned from the Swapi API.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch type {
        case .characters:
            return characters[row].name
        case .vehicles:
            return vehicles[row].name
        case .starships:
            return starships[row].name
        }
    }
    
    // Configures the view according the entity the user selects with the pickerView.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        configureView()
    }
}
