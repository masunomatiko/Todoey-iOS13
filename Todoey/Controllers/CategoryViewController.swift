//
//  CategoryViewController.swift
//  Todoey
//
//  Created by 佐藤万莉 on 2020/05/14.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

import RealmSwift

class CategoryViewController: SwipeTableViewController {
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added"
        
        return cell
    }

    func loadCategories() {
        
        categoryArray = realm.objects(Category.self)
        print(categoryArray)
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
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    override func updateModel(at indexPath: IndexPath) {

        if let categoryForDeletion = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print(error)
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
        alert.addAction(action)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }

        present(alert, animated: true, completion: nil)
        
        
//        MARK: - Tableview Detasource Methods
        
//        MARK: - Tableview Delegate Methods
        
//        MARK: - Tableview Data Manipulation Methods
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
}


