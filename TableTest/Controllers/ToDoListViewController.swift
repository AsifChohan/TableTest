//
//  ViewController.swift
//  TableTest
//
//  Created by AlveenaFalaq on 1/3/18.
//  Copyright © 2018 AlveenaFalaq. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    //Array object of item class
    
      var dummyData = [Item]()
      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // To set the data storage path
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       //  loadData()
           }

    //MARK - TableView datasource method

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let itemRow = dummyData[indexPath.row]
        cell.textLabel?.text = itemRow.item
        
       
        
        //Using Ternary operator to cut short the if else
        cell.accessoryType = itemRow.state ? .checkmark : .none
        
//        if dummyData[indexPath.row].state == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    
    //MARK  - TableView delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print (dummyData[indexPath.row])
        
        
        
        //Toggle the stat of the row
//        if dummyData[indexPath.row].state == true {
//                dummyData[indexPath.row].state = false
//        }else {
//                dummyData[indexPath.row].state = true
//        }
        
        // Short for the above commented line .Setting the state property of current item to opposite.
        dummyData[indexPath.row].state = !dummyData[indexPath.row].state
        
        self.saveItem()
       // tableView.reloadData()


       tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK - Add New Items
    
    @IBAction func barButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            
            let newitem = Item(context: self.context)
            newitem.item = textField.text!
            newitem.state = false
            self.dummyData.append(newitem)
            
            self.saveItem()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
           
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil )
    }
    
    func saveItem(){
        
        do {
            try context.save()
        } catch {
            print ("Error saving date \(error)")
        }
        
        tableView.reloadData()
   }
//    func loadData() {
//        if let  data = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                dummyData = try decoder.decode([Item].self, from: data)
//            } catch {
//                print ("Error Decoding Data")
//            }
//        }
//    }
    
//    func loadData() {
//        let fetchRequest = Item(context: context)
//        do{
//            dummyData = try fetchRequest.
//        } catch {
//
//        }
//
//    }
    
}


