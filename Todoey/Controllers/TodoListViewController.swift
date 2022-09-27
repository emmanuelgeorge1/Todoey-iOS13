//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy gasilone","Kill demogorgan"]
    let defalut = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defalut.array(forKey: "ToDoListArray") as? [String]{
            itemArray = items
        }
     
    }
    // datasource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier:"ToDoItemCell" , for: indexPath)
        cell.textLabel?.text = message
        return cell
    }
    //delgate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
  //Add items
    
    @IBAction func addItemPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New To Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            self.defalut.set(self.itemArray, forKey: "ToDoListArray")
            self.tableView.reloadData()
        }
        alert.addTextField(configurationHandler: {(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        })
        alert.addAction(action)
        present(alert, animated: true)
    }
    


}

