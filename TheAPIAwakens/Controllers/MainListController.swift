//
//  MainListController.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

class MainListController: UITableViewController {

    let entities = MainMenuData.mainMenuEntities
    let client = SwapiClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    // Populates the tableView with objects that represent Star Wars entities (Characters, Vehicles, and Starships).
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntityCell", for: indexPath) as! EntityTableViewCell

        cell.entityImage.image = entities[indexPath.row].icon
        cell.entityLabel.text = entities[indexPath.row].type.description
        
        return cell
    }

    // Based on the cell selected, the MainListController passes a Star Wars entity type to the DetailListController.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEntity" {
            let destination = segue.destination as! DetailListController

            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                let selectedEntityType = entities[selectedIndexPath.row].type
                destination.type = selectedEntityType
            }
        }
    }
}
