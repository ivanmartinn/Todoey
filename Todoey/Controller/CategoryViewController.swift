//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Ivan Martin on 14/03/2019.
//  Copyright © 2019 Ivan Martin. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    //for realm
    let realm = try! Realm()
    var categories : Results<Categories>?
    
    //for coredata
//    var categoryArray = [Category]()
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        //for core data
//        loadData()
        
        //for realm (disable if you want to test the default value)
        loadCategories()
        
        //for swipecell
//        tableView.rowHeight = 80.0
        
    }
    
    //MARK: - TableView datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //for coredata
//        return categoryArray.count
        
        //for realm
        return categories?.count ?? 1// nil coalescing operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //for super class swiptetable
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        
        //for coredata
//        let category = categoryArray[indexPath.row]
//        cell.textLabel?.text = category.name
        
        //for realm
        if let category = categories?[indexPath.row]{
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            cell.textLabel?.text = category.name
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        else{
            cell.textLabel?.text = "No categories added yet"
        }
        return cell
    }
    
    //MARK: - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //select cell
        performSegue(withIdentifier: "goToItem", sender: self)
    }
    
    //before perform seque
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            //for coredata
//            destinationVC.selectedCategory = categoryArray[indexPath.row]
            //for realm
            destinationVC.selectedCategories = categories?[indexPath.row]
        }
    }
    
    //MARK: - add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            
            if textfield.text != nil || textfield.text != ""{
                //for coredata
//                let category = Category(context: self.context)
//                category.name = textfield.text
//                self.categoryArray.append(category)
//                self.saveData()
                
                //for realm
                let newCategory = Categories()
                newCategory.name = textfield.text!
                newCategory.colour = UIColor.randomFlat.hexValue()
                /*appending is not require because it is auto update*/
                self.saveCategories(categories: newCategory)
            }
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New category"
            textfield = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation methods
    
    //for coredata
/*    func saveData(){
        do{
            try context.save()
        }catch{
            print("error save category, \(error)")
        }
        tableView.reloadData()
    }
     
    func loadData(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("error load category, \(error)")
        }
        tableView.reloadData()
    }*/
    
    //for realm
    func saveCategories(categories: Categories){
        do{
            try realm.write {
                realm.add(categories)
            }
        }catch{
            print("error save category, \(error)")
        }
        tableView.reloadData()
    }
    //load
    func loadCategories(){
        categories = realm.objects(Categories.self)
        tableView.reloadData()
    }
    //delete
    override func updateModel(at indexPath: IndexPath) {
        //for realm
        if let category = categories?[indexPath.row] {
            do{
                try realm.write {
                    //MARK: - Realm Delete
                    realm.delete(category)
                    //no need tablereload for delete using swipe
                }
            }catch{
                print("error deleting category, \(error)")
            }
        }
    }
}
