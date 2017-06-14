//
//  ViewController.swift
//  coreDataToDoApp
//
//  Created by Andre Dias on 13/06/17.
//  Copyright © 2017 Andre Dias. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var items = [NSManagedObject]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let item = items[indexPath.row]
        cell.textLabel?.text = item.value(forKey: "name") as? String
        return cell
    }
    
    @IBAction func addItem(_ sender: Any) {
        let alert = UIAlertController(title: "New item", message: "Add a new item", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            self.saveItem(name: textField.text!)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alert.addTextField(configurationHandler: nil)
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func removeItem(_ sender: Any) {
        
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
        }else{
            self.tableView.setEditing(true, animated: true)
        }
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fetchData()
        
        title = "To Do"
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let item = items[indexPath.row]
        
        if editingStyle == .delete {
            managedContext.delete(item)
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error While Deleting Note: \(error.userInfo)")
            }
            
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        do {
            items = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Error While Fetching Data From DB: \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    func saveItem(name: String) {
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedContext!)
        let item = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        item.setValue(name, forKey: "name")
        
        do {
            try managedContext?.save()
            items.append(item)
        }catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchData() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = appDelegate?.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        
        do {
            items = try managedContext?.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }


}

