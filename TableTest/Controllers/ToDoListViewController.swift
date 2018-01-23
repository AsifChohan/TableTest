//
//  ViewController.swift
//  TableTest
//
//  Created by AlveenaFalaq on 1/3/18.
//  Copyright © 2018 AlveenaFalaq. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    //Array object of item class
    
    let realm = try! Realm()
    var todoItems: Results<Item>?
    var selectCategory : Category? {
        didSet{
           loadData()
        }
    }
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadData()
    }
    
    //MARK - TableView datasource method
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)

        if  let itemRow = todoItems?[indexPath.row] {
        cell.textLabel?.text = itemRow.item
        cell.accessoryType = itemRow.state ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added Yet"
        }
        return cell
    }

    
    //MARK  - TableView delegate Methods
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    if let item = todoItems?[indexPath.row]{
        do {
            try realm.write {
                
             //Delete data from Realm
             //   realm.delete(item)
                item.state = !item.state
            }
        }catch {
            print ("Error \(error)")
        }
        
    }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    //MARK - Add New Items
    
    @IBAction func barButton(_ sender: UIBarButtonItem) {

        var textField = UITextField()

        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in

            
          if  let currentCategory = self.selectCategory {
                
                do {
                    try self.realm.write {
                        let newitem = Item()
                        newitem.item = textField.text!
                        newitem.dateCreated = Date()
                        currentCategory.items.append(newitem)
                    }
                } catch {
                    print ("Error \(error)")
                }
            }
        
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil )
    }
    
    
    
    func loadData() {
        
        todoItems = selectCategory?.items.sorted(byKeyPath: "item", ascending: true)
        
        tableView.reloadData()
    }
    
}
//MARK -- SearchBar methods,instead adding to main class use extension

extension ToDoListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
       // todoItems = todoItems?.filter("item CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "item",ascending: true)
       todoItems = todoItems?.filter("item CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated",ascending: true)
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "item CONTAINS[cd] %@", searchBar.text!)
//
//        request.sortDescriptors = [NSSortDescriptor(key: "item", ascending: true)]
//
//        loadData(with: request,predicate: predicate)
        tableView.reloadData()

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











