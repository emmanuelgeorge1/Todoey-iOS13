//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Emmanuel George on 01/09/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    let realm = try! Realm()
    var categories : Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorColor = .none
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller doest exist")
        }
        navBar.backgroundColor = UIColor(hexString: "1D98")
    }
    //MARK:- tableView DataSource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
        //nil coalescing oprator
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        let color = UIColor(hexString: categories?[indexPath.row].colour ?? "32ADE6")
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
        return cell
    }
    //MARK:- tableView Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "GoToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexpath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexpath.row]
        }
    }

    //MARK:- Data Manupulation methods
    func save(category:Category){
        do{
            try realm.write({
                realm.add(category)
            })

        }catch{
      print("Error saving context\(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories(){
       categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
//MARK:- delete data from swipe
    override func updateModel(at indexPath:IndexPath){
        super.updateModel(at: indexPath)
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do{
                try self.realm.write({
                    self.realm.delete(categoryForDeletion)
                    
                })
            }catch{
                print("Error saving done status \(error)")
            }
        }
    }
    
    
    
    
    
//MARK:- Add new Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New To Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.colour = UIColor.randomFlat().hexValue()
            
            self.save(category: newCategory)
        }
        alert.addAction(action)
        alert.addTextField{(field) in
            textField = field
            textField.placeholder = "Create new item"
          
        }
        present(alert, animated: true)
    }
}
