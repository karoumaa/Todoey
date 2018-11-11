//
//  ViewController.swift
//  Todoey
//
//  Created by user on 09/11/2018.
//  Copyright © 2018 karama. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    

    var itemArray: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist"))
        
        
    }
        // Do any additional setup after loading the view, typically from a nib.
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = itemArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No items added yet"
        }
      
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        if let item = itemArray?[indexPath.row]{
            do{  try realm.write {
            
               item.done = !item.done
                }}catch{
                    print("error saving done status")
            }
            
            tableView.reloadData()
      
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }

  @IBAction func AddButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Todoey Item ", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success")
            
            if let currentCategory = self.selectedCategory {
                
                do{
                    try self.realm.write {
            let newItem = Item()
            newItem.title = textField.text!
            newItem.dateCreated = Date()
            currentCategory.items.append(newItem)
                    }
                }catch{
                    print("error saving context")
                }
            }
            self.tableView.reloadData()
          
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            }
        
        alert.addAction(action)
        present(alert , animated: true , completion: nil)
    }
    
     func  save(item : Item) {
     
     do{
     try realm.write {
     realm.add(item)
     }
     }catch{
     print("error saving context")
     }
     
     tableView.reloadData()
     

        
    }
    
    func loadItems( ) {

     itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
            
        tableView.reloadData()

    }
    
    
}

extension TodoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
       itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchBar.text?.count == 0
        {
            loadItems()
            DispatchQueue.main.async {
             searchBar.resignFirstResponder()
            }
            
        }
    }

}
