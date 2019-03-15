//
//  ViewController.swift
//  Todoey
//
//  Created by Ivan Martin on 05/03/2019.
//  Copyright © 2019 Ivan Martin. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController{

//    var itemArray : [String] = [String]()//user defaults cannot hold object
    var itemArray = [Item]()//class if filemanager or entity core data.
    
    //get data from previous controller
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    //user default only for basic and certain amount of data
//    let userDefault = UserDefaults.standard
    
    //fileManager/codeable method
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //core data method
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //get path of filemanager (in document)/core data are not inside doc but library/application support
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //get data using filemanager method below
//        loadItem()
        
        //for coredata
//        loadItems()//disabled because of category. unless if you want to display whole list
        
        //get data user default(value will be not inside document but /library/preferences)
//        if let items = userDefault.array(forKey: "ToDoList") as? [Item]{
//            itemArray = items
//        }
        
    }

    // MARK: - TableView Datasource Methods
    
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
    
    // MARK: - Tableview delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //for nsobject or datamodel
//        itemArray[indexPath.row].setValue(true, forKey: "done")
        
        //MARK: - datamodel delete
//        context.delete(itemArray[indexPath.row])//delete from context first
//        itemArray.remove(at: indexPath.row)//delete from array for viewlist
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //easiest way to revert to opposite value
//        if itemArray[indexPath.row].done == false{
//            itemArray[indexPath.row].done = true
//        }else{
//            itemArray[indexPath.row].done = false
//        }
        
        //MARK: - update
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//            print(textField.text!)
            if textField.text != nil && textField.text != ""{
//                self.itemArray.append(textField.text ?? "New Item" )// if empty then fill with name of "new item"
//                print("saved to plist")
//                print("item : \(String(describing: textField.text))")
                
                //for normal class
//                let newItem = Item()
                
                //for core data
                let newItem = Item(context: self.context)
                newItem.done = false //dont have default value like class
                
                newItem.title = textField.text!
                
                //relationship
                newItem.parentCategory = self.selectedCategory
                
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
    
    // MARK: - Model manipulation methods
    
    func saveItems(){
        //save data using filemanager method
//        let encoder = PropertyListEncoder()
//        do{
//            let data = try encoder.encode(itemArray)
//            try data.write(to: dataFilePath!)
//        }catch{
//            print("Error encoding item array, \(error)")
//        }
        
        
        //save data using core data method
        do{
            try context.save()
        }catch{
            print("error saving data \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //get data using filemanager
    /*func loadItem(){
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array, \(error)")
            }
        }
    }*/
    
    //load data using core data
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), and predicate : NSPredicate? = nil){
        /*func name(external iternal : type = default value
        external is used when calling the func while internal is a variable used inside the func*/
        
        //forceunwrap because new view controller will be redirect from selectedCategory
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additonalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additonalPredicate])
        }
        else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("error fetching data from context \(error)")
        }
        tableView.reloadData()
    }
    
}

// MARK: - SearchBar delegate method
extension TodoListViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        request.sortDescriptors = [sortDescriptor]
//        loadItems(with: request)
        loadItems(with: request, and: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {//to execute it without waiting for the previous func to finished
                searchBar.resignFirstResponder()//remove focus
            }
            
            
        }
    }
}
