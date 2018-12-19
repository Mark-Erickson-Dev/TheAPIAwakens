//
//  ViewController.swift
//  TheAPIAwakens
//
//  Created by Mark Erickson on 8/18/18.
//  Copyright © 2018 Mark Erickson. All rights reserved.
//

import UIKit

class MainListController: UITableViewController {

    //let entities = SWEntityData.entities
    let entities = MainMenuData.mainMenuEntities
    
    
    //var selectedEntity: Entity!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //selectedEntity = entities[0]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EntityCell", for: indexPath) as! EntityTableViewCell
        
        //cell.entityImage.image = entities[indexPath.row].icon
        //cell.entityLabel.text = entities[indexPath.row].type.rawValue
        
        cell.entityImage.image = entities[indexPath.row].icon
        cell.entityLabel.text = entities[indexPath.row].type.rawValue
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedEntity = entities[indexPath.row]
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEntity" {
            let destination = segue.destination as! DetailListController

            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                //let selectedEntity = entities[selectedIndexPath.row]
                //destination.entity = selectedEntity
                
                let selectedEntityType = entities[selectedIndexPath.row].type
                destination.type = selectedEntityType
            }
        }
    }
}






































