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
    var selectCategory : Category? {
        didSet{
            loadData()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
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
        
        // update core data example
        // dummyData[indexPath.row].setValue("complete", forKey: "item")
        
        //Delete core data eample order matters here .First delete the context
        // context.delete(dummyData[indexPath.row])
        // dummyData.remove(at: indexPath.row)
        
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
            newitem.parentCategory = self.selectCategory
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
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", (selectCategory?.name!)!)
        
        if predicate != nil {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,predicate!])
        } else {
            request.predicate = categoryPredicate
        }
        
        
        do{
            dummyData = try context.fetch(request)
        } catch {
            print ("Error Reading data from context \(error)")
        }
        tableView.reloadData()
    }
    
}
//MARK -- SearchBar methods,instead adding to main class use extension

extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "item CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true)]
        
        loadData(with: request,predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}











