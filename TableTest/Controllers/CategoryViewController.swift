//
//  CategoryViewController.swift
//  TableTest
//
//  Created by AlveenaFalaq on 1/14/18.
//  Copyright © 2018 AlveenaFalaq. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    
    let realm = try! Realm()
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.separatorStyle = .none
        
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
        cell.textLabel?.text = category.name
        
        guard let categoryColor = UIColor(hexString: category.color) else { fatalError()}
        cell.backgroundColor = categoryColor
        cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
    }
    
    //MARK:- Table delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK:- Table View Data Manupulation
    
    func save(category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch {
            print ("Error Saving Data\(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategory(){
        
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    //MARK: - Delete data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoriesToDelete = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoriesToDelete)
                }
            }
            catch {
                print ("Error Deleting\(error)")
            }
            
        }
        
    }
    
    // MARK:- Add new Category
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCat = Category()
            newCat.name = textField.text!
            newCat.color = UIColor.randomFlat.hexValue()
            
            self.save(category: newCat)
        }
        
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Create New Category"
            textField = alerttextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}










