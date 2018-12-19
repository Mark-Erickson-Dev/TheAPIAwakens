//
//  MehTableViewController.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/19/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

class DetailListController: UITableViewController {

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
    
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var metricButton: UIButton!
    @IBOutlet weak var usdButton: UIButton!
    @IBOutlet weak var creditsButton: UIButton!
    
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    let vehicles = Stub.vehicles
    let characters = Stub.characters
    let starships = Stub.starships
    var character: Character!
    var vehicle: Vehicle!
    var starship: Starship!
    var selectedEntities = [SWEntity]()
    var type: SWEntityType?
    var isMeters: Bool = true
    var isCredits: Bool = true
    var rate: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.sectionHeaderHeight = 0
        tableView.sectionFooterHeight = 1
        metricButton.setTitleColor(UIColor.white, for: .normal)
        creditsButton.setTitleColor(UIColor.white, for: .normal)
        
        pickerView.dataSource = self
        pickerView.delegate = self

        if let entityType = type {
            
            self.navigationItem.title = entityType.rawValue
            
            switch entityType {
                case .character:
                    selectedEntities = characters
                    //character = characters[0]
                    configureView(for: characters[0])
                
                case .vehicle:
                    selectedEntities = vehicles
                    //vehicle = vehicles[0]
                    configureView(for: vehicles[0])
                
                case .starship:
                    selectedEntities = starships
                    //starship = starships[0]
                    configureView(for: starships[0])
            }
            
            setupUI()
        }
    }

    func configureView(for character: Character) {
    
        nameLabel.text = character.name
        bornLabel.text = character.birthYear
        homeLabel.text = character.homeworld
        
        if isMeters == false {
            let roundedHeightInInches = convertMetersToEnglish(measurement: character.height)
            heightLabel.text = "\(roundedHeightInInches)in"
        } else {
            heightLabel.text = "\(character.height)m"
        }
        
        eyesLabel.text = character.eyeColor
        hairLabel.text = character.hairColor
    }
    
    func configureView(for vehicle: Vehicle) {
        
        nameLabel.text = vehicle.name
        makeLabel.text = vehicle.manufacturer
        
        if let cost = vehicle.costInCredits {
            if isCredits == false {
                let convertedCost = convertCreditsToUSD(credits: cost, rate: rate)
                costLabel.text = "$\(convertedCost)"
            } else {
                costLabel.text = "\(cost)"
            }
        } else {
            costLabel.text = "unknown"
        }
        
        if isMeters == false {
            let roundedLengthInInches = convertMetersToEnglish(measurement: vehicle.length)
            lengthLabel.text = "\(roundedLengthInInches)in"
        } else {
            lengthLabel.text = "\(vehicle.length)m"
        }
        
        classLabel.text = vehicle.vehicleClass
        crewLabel.text = "\(vehicle.crew)"
    }
    
    func showLabels(of collection: [UILabel]) {
        for label in collection {
            label.isHidden = false
        }
    }
    
    func hideLabels(of collection: [UILabel]) {
        for label in collection {
            label.isHidden = true
        }
    }
    
    func setupUI() {
        
        if type == .character {
            hideLabels(of: specLabelCollection)
            hideLabels(of: specValueLabelCollection)
            showLabels(of: traitLabelCollection)
            showLabels(of: traitValueLabelCollection)
            usdButton.isHidden = true
            creditsButton.isHidden = true
            
            let sortedCharacters = characters.sorted(by: {$0.height < $1.height})
            //print(sortedCharacters.map({$0.name}))
            setSmallestAndLargestLabels(smallest: sortedCharacters.first?.name, largest: sortedCharacters.last?.name)
            
        } else {
            hideLabels(of: traitLabelCollection)
            hideLabels(of: traitValueLabelCollection)
            showLabels(of: specLabelCollection)
            showLabels(of: specValueLabelCollection)
            usdButton.isHidden = false
            creditsButton.isHidden = false
            
            if type == .vehicle {
                let sortedVehicles = vehicles.sorted(by: {$0.length < $1.length})
                //print(sortedVehicles.map({$0.name}))
                setSmallestAndLargestLabels(smallest: sortedVehicles.first?.name, largest: sortedVehicles.last?.name)
                
            } else {
                let sortedStarships = starships.sorted(by: {$0.length < $1.length})
                //print(sortedStarships.map({$0.name}))
                setSmallestAndLargestLabels(smallest: sortedStarships.first?.name, largest: sortedStarships.last?.name)
            }
        }
    }
    
    func setSmallestAndLargestLabels(smallest: String?, largest: String?) {
        
        smallestLabel.text = smallest
        largestLabel.text = largest
    }
    
    @IBAction func usdButtonTapped(_ sender: Any) {
        
        isCredits = false
        let alert = UIAlertController(title: "Credit Conversion", message: "Enter an exchange rate", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.text = "\(self.rate)"
        }
        alert.addAction(UIAlertAction(title: "Convert", style: .default, handler: { [weak alert] (_) in
            guard let alert = alert, let textField = alert.textFields?[0] else {
                return
            }
            //print("Text field: \(textField.text ?? "")")
            guard let text = textField.text, let rateAsDouble = Double(text) else {

                return
            }
            
            do {
                try self.rate = self.validateRate(rate: rateAsDouble)

                self.creditsButton.setTitleColor(UIColor.gray, for: .normal)
                self.usdButton.setTitleColor(UIColor.white, for: .normal)

                if let entityType = self.type {
                    if entityType == .vehicle {
                        if let cost = self.vehicle.costInCredits {
                            let convertedCost = self.convertCreditsToUSD(credits: cost, rate: self.rate)
                            self.costLabel.text = "$\(convertedCost)"
                        }
                    } else if entityType == .starship {
                        if let cost = self.starship.costInCredits {
                            let convertedCost = self.convertCreditsToUSD(credits: cost, rate: self.rate)
                            self.costLabel.text = "$\(convertedCost)"
                        }
                    }
                }

            } catch DataError.InvalidRate {
                Alert.showErrorAlert(title: "Data Error", message: DataError.InvalidRate.description, vc: self)
                return

            } catch let error {
                print(error)
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func validateRate(rate: Double) throws -> Double {
        
        guard rate > 0 else {
            
            throw DataError.InvalidRate
        }
        
        return rate
    }
    
    @IBAction func creditsButtonTapped(_ sender: Any) {
        
        isCredits = true
        usdButton.setTitleColor(UIColor.gray, for: .normal)
        creditsButton.setTitleColor(UIColor.white, for: .normal)
        
        if let entityType = type {
            if entityType == .vehicle {
                if let cost = vehicle.costInCredits {
                    costLabel.text = "\(cost)"
                }
            } else if entityType == .starship {
                if let cost = starship.costInCredits {
                    costLabel.text = "\(cost)"
                }
            }
        }
    }
    
    func convertCreditsToUSD(credits: Int, rate: Double) -> Int {
        
        return Int(round(100 * (Double(credits) * rate))/100)
    }
    
    @IBAction func englishButtonTapped(_ sender: Any) {
        
        isMeters = false
        metricButton.setTitleColor(UIColor.gray, for: .normal)
        englishButton.setTitleColor(UIColor.white, for: .normal)
        
        if let entityType = type {
            if entityType == .character {
                let roundedHeightInInches = convertMetersToEnglish(measurement: character.height)
                heightLabel.text = "\(roundedHeightInInches)in"
                
            } else if entityType == .vehicle {
                let roundedLengthInInches = convertMetersToEnglish(measurement: vehicle.length)
                lengthLabel.text = "\(roundedLengthInInches)in"
            } else {
                let roundedLengthInInches = convertMetersToEnglish(measurement: starship.length)
                lengthLabel.text = "\(roundedLengthInInches)in"
            }
        }
    }
    
    @IBAction func metricButtonTapped(_ sender: Any) {
        
        isMeters = true
        englishButton.setTitleColor(UIColor.gray, for: .normal)
        metricButton.setTitleColor(UIColor.white, for: .normal)
        
        if let entityType = type {
            if entityType == .character {
                heightLabel.text = "\(character.height)m"
                
            } else if entityType == .vehicle {
                lengthLabel.text = "\(vehicle.length)m"
            } else {
                lengthLabel.text = "\(starship.length)m"
            }
        }
    }
    
    func convertMetersToEnglish(measurement: Double) -> Double {
    
        return Double(round(100 * (measurement * 39.370079))/100)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension DetailListController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
 
        return selectedEntities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if let entityType = type {
            if entityType == .character {
                return characters[row].name
            } else if entityType == .vehicle {
                return vehicles[row].name
            } else {
                return starships[row].name
            }
        } else {
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if type == .character {
            character = characters[row]
            configureView(for: character)
        } else if type == .vehicle {
            vehicle = vehicles[row]
            configureView(for: vehicle)
        } else {
            starship = starships[row]
            configureView(for: starship)
        }
    }
}
