//
//  CategoryViewController.swift
//  Todoey
//
//  Created by user on 10/11/2018.
//  Copyright © 2018 karama. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
   
    var categoryArray: Results<Category>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       loadCategories()

      }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

          cell.textLabel?.text =  categoryArray?[indexPath.row].name ?? "No Categories added yet"
       
        
        return cell    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Category ", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert , animated: true , completion: nil)
        
        
        
    }
    
    
    func  save(category : Category) {
        
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("error saving context")
        }
        
        tableView.reloadData()
        
        
    }
    
    func loadCategories() {
        
         categoryArray = realm.objects(Category.self)
       
        tableView.reloadData()
        
    }
    

}
