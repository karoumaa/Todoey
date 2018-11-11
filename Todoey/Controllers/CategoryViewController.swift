//
//  CategoryViewController.swift
//  Todoey
//
//  Created by user on 10/11/2018.
//  Copyright © 2018 karama. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

      }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        let category = categoryArray[indexPath.row]
        cell.textLabel?.text = category.name
        
        return cell    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
       
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Category ", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
    
            self.categoryArray.append(newCategory)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert , animated: true , completion: nil)
        
        
        
    }
    
    
    func  saveItems() {
        
        do{
            try context.save()
        }catch{
            print("error saving context")
        }
        
        tableView.reloadData()
        
        
    }
    
    func loadCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        
        do { categoryArray = try context.fetch(request)}
        catch{
            print("Error fetching data from context")
        }
        
        tableView.reloadData()
        
    }
    

}
