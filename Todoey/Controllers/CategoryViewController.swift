//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 佐藤万莉 on 2020/05/14.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import UIKit

import RealmSwift

class CategoryViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    let realm = try! Realm()
  
    var categoryArray: Results<Category>?

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let todoVC = segue.destination as! TodoListViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                todoVC.selectedCategory = categoryArray?[indexPath.row]
            }
        }
    }
    

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "AddItem", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil) 
        
        
//        MARK: - Tableview Detasource Methods
        
//        MARK: - Tableview Delegate Methods
        
//        MARK: - Tableview Data Manipulation Methods
    }
    
    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
}


