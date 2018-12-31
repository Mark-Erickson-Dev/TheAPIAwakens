//
//  MehTableViewController.swift
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
    
    var associatedStarships: [Starship]!

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
        
        characters = [Character]()//Stub.dummyCharacters
        vehicles = Stub.dummyVehicles
        starships = Stub.dummyStarships
        
        defaultView()
        getSwapiData()
    }
    
    func defaultView() {
        self.navigationItem.title = type.rawValue
        
        allButtons.forEach({$0.isEnabled = false})
        metricButtons.forEach({$0.setTitleColor(.white, for: .normal)})
        creditsButton.setTitleColor(UIColor.white, for: .normal)

        setupUI()
        nameLabel.text = ""
        vehicleTextView.text = ""
        starshipTextView.text = ""
        
        traitValueLabelCollection.forEach({$0.text = ""})
        specValueLabelCollection.forEach({$0.text = ""})

        smallestLabel.text = ""
        largestLabel.text = ""
    }
    
    func meh(array: [SWEntity]) {
        self.configureView()
        self.pickerView.reloadAllComponents()
        self.setSmallestAndLargestLabels(array: array)
        self.allButtons.forEach({$0.isEnabled = true})
        self.activityIndicator.stopAnimating()
    }
    
    func getSwapiData() {
        activityIndicator.startAnimating()
        client.getData(for: type) { results, error in

            if let results = results {
                switch self.type {
                case .characters:
                    self.characters = results as? [Character]
                    self.entityCount = self.characters.count
                    //self.characters.forEach({print($0.name)})
                    print("\nCharacter count: \(self.characters.count)")
                case .vehicles:
                    self.vehicles = results as? [Vehicle]
                    self.entityCount = self.vehicles.count
                    //self.vehicles.forEach({print($0.name)})
                    print("\nVehicle count: \(self.vehicles.count)")
                case .starships:
                    self.starships = results as? [Starship]
                    self.entityCount = self.starships.count
                    //self.starships.forEach({print($0.name)})
                    print("\nStarship count: \(self.starships.count)")
                }

                self.configureView()
                self.pickerView.reloadAllComponents()
                self.setSmallestAndLargestLabels(array: results)
                self.allButtons.forEach({$0.isEnabled = true})
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func configureView() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        
        switch type {
        case .characters:
            let character = characters[selectedRow]
            nameLabel.text = character.name
            bornLabel.text = character.birthYear
            
            client.getData(for: character.homeworld) { (result: Planet?, error) in
                if let planet = result {
                    DispatchQueue.main.async {
                        self.homeLabel.text = planet.name
                    }
                }
            }

            heightLabel.text = makeMeasurement(from: character.length)
            eyesLabel.text = character.eyeColor
            hairLabel.text = character.hairColor

            starshipTextView.text = ""
            if character.starships.isEmpty {
                self.starshipTextView.text += "No associated starships."
            } else {
                var names = [String]()
                for starshipUrl in character.starships {
                    client.getData(for: starshipUrl) { (result: Starship?, error) in
                        if let starship = result {
                            DispatchQueue.main.async {
                                names.append(starship.name)
                                let joinedString = names.joined(separator: ", ")
                                self.starshipTextView.text = "Associated starships: " + joinedString
                            }
                        }
                    }
                }
            }

            vehicleTextView.text = ""
            if character.vehicles.isEmpty {
                self.vehicleTextView.text += "No associated vehicles."
            } else {
                var names = [String]()
                for vehicleUrl in character.vehicles {
                    client.getData(for: vehicleUrl) { (result: Vehicle?, error) in
                        if let vehicle = result {
                            DispatchQueue.main.async {
                                names.append(vehicle.name)
                                let joinedString = names.joined(separator: ", ")
                                self.vehicleTextView.text = "Associated vehicles: " + joinedString
                            }
                        }
                    }
                }
            }
            
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

    func makeCost(from cost: String) -> String {
        var finalCost: Int = 0
        
        guard cost != "unknown" else {
            return "unknown"
        }
        
        if let cost = Int(cost) {
            if isCredits == false {
                finalCost = convertCreditsToUSD(credits: cost, rate: rate)
                return "$\(finalCost)"
            } else {
                return "\(cost)"
            }
        } else {
            return ""
        }
    }
    
    func makeMeasurement(from measurementAsString: String) -> String {
        
        guard measurementAsString != "unknown" else {
            return "unknown"
        }
        
        let cleanString = measurementAsString.replacingOccurrences(of: ",", with: "")
        
        var finalMeasurement: Double = 0
        if let measurement = Double(cleanString) {
            if isMeters == false {
                if type == .characters {
                    finalMeasurement = convertMetersToInches(measurementInMeters: measurement/100)
                    return "\(finalMeasurement)in"
                } else {
                    finalMeasurement = convertMetersToInches(measurementInMeters: measurement)
                    return "\(finalMeasurement)in"
                }
            } else {
                if type == .characters {
                    return "\(measurement/100)m"
                } else {
                    return "\(measurement)m"
                }
            }
        } else {
            return ""
        }
    }
    
    func convertMetersToInches(measurementInMeters: Double) -> Double {
        return Double(round(100 * (measurementInMeters * 39.370079))/100)
    }
    
    func convertCreditsToUSD(credits: Int, rate: Double) -> Int {
        return Int(round(100 * (Double(credits) * rate))/100)
    }
    
    func setupUI() {
        if type == .characters {
            specView.isHidden = true
            traitView.isHidden = false
        } else {
            traitView.isHidden = true
            specView.isHidden = false
        }
    }

    func setSmallestAndLargestLabels(array: [SWEntity]) {
        var cleanArray = [SWEntity]()

        array.forEach({
            let length = $0.length.replacingOccurrences(of: ",", with: "")
            if let _ = Double(length) {
                cleanArray.append($0)
            }
        })
        //cleanArray.forEach({print("\($0.name), \($0.length)")})
        //print("---------------")
        let sortedArray = cleanArray.sorted(by: {
            let length0 = $0.length.replacingOccurrences(of: ",", with: "")
            let length1 = $1.length.replacingOccurrences(of: ",", with: "")
            return Double(length0)! < Double(length1)!
        })
        //print("---------------")
        //sortedArray.forEach({print("\($0.name), \($0.length)")})
        
        smallestLabel.text = sortedArray.first?.name
        largestLabel.text = sortedArray.last?.name
    }
    
    @IBAction func usdButtonTapped(_ sender: Any) {
        let alert = Alert()
        alert.showRateAlert(vc: self) { result in
            self.rate = result
            DispatchQueue.main.async {
                self.toggleMonetaryUnit()
            }
        }
    }
    
    @IBAction func creditsButtonTapped(_ sender: Any) {
        toggleMonetaryUnit()
    }
    
    func setCostLabel() {
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        if type == .vehicles {
           costLabel.text = makeCost(from: vehicles[selectedRow].costInCredits)
        } else if type == .starships {
            costLabel.text = makeCost(from: starships[selectedRow].costInCredits)
        }
    }
    
    @IBAction func englishButtonTapped(_ sender: Any) {
        toggleMeasurementUnit()
    }
    
    @IBAction func metricButtonTapped(_ sender: Any) {
        toggleMeasurementUnit()
    }
    
    func toggleMonetaryUnit() {
        isCredits = !isCredits
        
        if isCredits {
            usdButton.setTitleColor(UIColor.gray, for: .normal)
            creditsButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            self.creditsButton.setTitleColor(UIColor.gray, for: .normal)
            self.usdButton.setTitleColor(UIColor.white, for: .normal)
        }
        
        setCostLabel()
    }
    
    func toggleMeasurementUnit() {
        isMeters = !isMeters
        
        if isMeters {
            englishButtons.forEach({$0.setTitleColor(.gray, for: .normal)})
            metricButtons.forEach({$0.setTitleColor(.white, for: .normal)})
        } else {
            metricButtons.forEach({$0.setTitleColor(.gray, for: .normal)})
            englishButtons.forEach({$0.setTitleColor(.white, for: .normal)})
        }
        
        setMeasurementLabel()
    }
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DetailListController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return entityCount
    }
    
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        configureView()
    }
}
