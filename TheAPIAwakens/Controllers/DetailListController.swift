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
    @IBOutlet var specValueLabelCollection: [UILabel]!
    @IBOutlet var traitValueLabelCollection: [UILabel]!
    @IBOutlet weak var smallestLabel: UILabel!
    @IBOutlet weak var largestLabel: UILabel!
    
    @IBOutlet weak var starshipTextView: UITextView!
    @IBOutlet weak var vehicleTextView: UITextView!
    
    @IBOutlet var allButtons: [UIButton]!
    @IBOutlet var metricButtons: [UIButton]!
    @IBOutlet weak var creditsButton: UIButton!

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var traitView: TraitView!
    @IBOutlet weak var specView: SpecView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    lazy var dataSource: PickerViewDataSource = {
        return PickerViewDataSource(pickerView: self.pickerView, traitView: self.traitView, specView: self.specView)
    }()

    var entities: [SWEntity]!

    var entityCount: Int = 0
    var type: SWEntityType = .characters
    var isMeters: Bool = true
    var isCredits: Bool = true
    var rate: Double = 0.0
    let client = SwapiClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = dataSource
        pickerView.dataSource = dataSource
        specView.parentVC = self

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
        
//        // Stub Data
//        switch type {
//        case .characters:
//            entities = Stub.characters
//            dataSource.update(with: Stub.characters, for: self.type)
//        case .vehicles:
//            entities = Stub.vehicles
//            dataSource.update(with: Stub.vehicles, for: self.type)
//        case .starships:
//            entities = Stub.starships
//            dataSource.update(with: Stub.starships, for: self.type)
//        }
//        allButtons.forEach({$0.isEnabled = true})
//        setSmallestAndLargestLabels(entityArray: entities)
        
        // Swapi Data
        activityIndicator.startAnimating()
        client.getData(for: type) { results, error in

            if let results = results {
                self.entityCount = results.count
                //self.entities = results
                self.dataSource.update(with: results, for: self.type)
                self.setSmallestAndLargestLabels(entityArray: results)
                self.allButtons.forEach({$0.isEnabled = true})
                self.activityIndicator.stopAnimating()
            }
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

}
