//
//  PickerViewDataSource.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 1/2/19.
//  Copyright © 2019 Mark Erickson. All rights reserved.
//

import UIKit

class PickerViewDataSource: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {

    let traitView: TraitView
    let specView: SpecView
    let pickerView: UIPickerView
    
    init(pickerView: UIPickerView, traitView: TraitView, specView: SpecView) {
        self.pickerView = pickerView
        self.traitView = traitView
        self.specView = specView
    }
    
    private var entities = [SWEntity]()
    private var characters = [Character]()
    private var vehicles = [Vehicle]()
    private var starships = [Starship]()
    
    var type: SWEntityType = .characters
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Tells the pickerView to populate a number of rows equal the count of entites returned from the Swapi API.
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return entities.count
    }
    
    // Populates the pickerView with the names of the entities returned from the Swapi API.
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return entities[row].name
    }
    
    // Configures the view according the entity the user selects with the pickerView.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        configureFor(entity: entities[row], type: type)
    }
    
    func update(with entities: [SWEntity], for type: SWEntityType) {
        self.entities = entities
        self.type = type
        pickerView.reloadAllComponents()
        configureFor(entity: entities[0], type: type)
    }
    
    func configureFor(entity: SWEntity, type: SWEntityType) {
        
        switch type {
            case .characters:
                traitView.character = entity as? Character
            case .vehicles:
                specView.vehicle = entity as? Vehicle
            case .starships:
                specView.starship = entity as? Starship
        }
    }
    
}
