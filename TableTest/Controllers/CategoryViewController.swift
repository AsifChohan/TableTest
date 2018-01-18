//
//  CategoryViewController.swift
//  TableTest
//
//  Created by AlveenaFalaq on 1/14/18.
//  Copyright © 2018 AlveenaFalaq. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray  = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    //MARK:- Table delegate
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK:- Table View Data Manupulation
    
    func saveCategory(){
        do{
            try context.save()
        }catch {
            print ("Error Saving Data\(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        //     let request :NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print ("Error fetching Data\(error)")
        }
        
        tableView.reloadData()
    }
    
    // MARK:- Add new Category
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCat = Category(context: self.context)
            newCat.name = textField.text!
            self.categoryArray.append(newCat)
            self.saveCategory()
        }
        
        alert.addTextField { (alerttextfield) in
            alerttextfield.placeholder = "Create New Category"
            textField = alerttextfield
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}











