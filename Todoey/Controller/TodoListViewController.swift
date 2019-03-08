//
//  ViewController.swift
//  Todoey
//
//  Created by Ivan Martin on 05/03/2019.
//  Copyright © 2019 Ivan Martin. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

//    var itemArray : [String] = [String]()
    var itemArray = [Item]()
    
    //user default only for basic and certain amount of data
//    let userDefault = UserDefaults.standard
    
    //fileManager method
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //get path of filemanager
//        print("\(String(describing: dataFilePath))")
        
        //get data using filemanager method below
        loadItems()
        
        //get data user default(value will be not inside document but /library/preferences)
//        if let items = userDefault.array(forKey: "ToDoList") as? [Item]{
//            itemArray = items
//        }
        
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        //ternary operator
        //value = condition ? valueIfTrue : valueIfFalse
//        cell.accessoryType = item.done == true ? .checkmark : .none
        //bool can be replaced if the variable contained bool in condition statement
        cell.accessoryType = item.done ? .checkmark : .none
        //long way
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
        return cell
        
    }
    
    //Mark: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //easiest way to revert to opposite value
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK: - Add new items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//            print(textField.text!)
            if textField.text != nil && textField.text != ""{
//                self.itemArray.append(textField.text ?? "New Item" )// if empty then fill with name of "new item"
//                print("saved to plist")
//                print("item : \(String(describing: textField.text))")
                let newItem = Item()
                newItem.title = textField.text!
                self.itemArray.append(newItem)
                //save data using user defaults
//                self.userDefault.set(self.itemArray, forKey: "ToDoList")
                
                //using filemanager method below
                self.saveItems()
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Todoey"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Model manipulation methods
    func saveItems(){
        //save data using filemanager method
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadItems(){
        //get data using filemanager
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array, \(error)")
            }
        }
    }
    
}

