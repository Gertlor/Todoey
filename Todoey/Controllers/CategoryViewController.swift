//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Gerrit Louis on 25-03-18.
//  Copyright © 2018 Gerrit Louis de Beuze. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
  
    
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name ?? "No Categories added yet"
            
            guard let categoryColor = UIColor(hexString: category.color) else { fatalError()}
            
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        
        
        
     
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    func saveCategories(category: Category){
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving categorie \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadCategories(){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                print(error)
            }
        }
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textfield.text!
            newCategory.color = UIColor.randomFlat.hexValue()

            self.saveCategories(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField { (field) in
            textfield = field
            textfield.placeholder = "Add a new category"
        }
        present(alert, animated: true, completion: nil)
    }
}
