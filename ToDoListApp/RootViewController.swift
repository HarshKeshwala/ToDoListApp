//
//  RootViewController.swift
//  ToDoListApp
//
//  Created by Harsh Keshwala on 2018-11-29.
//  Copyright © 2018 CentennialCollege. All rights reserved.
//

import UIKit
import CoreData

//var list = ["A", "B", "C", "D"]

class RootViewController: UITableViewController {

    var tasks = [ToDoEntity]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var tasksList: UITableView!
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem)
    {
        showInputDialog()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return (list.count)
        return (tasks.count)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.name
        
        cell.accessoryType = task.completed ? .checkmark : .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        tasks[indexPath.row].completed = !tasks[indexPath.row].completed
        saveTasks()
    }
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            tasks.remove(at: indexPath.row)
            context.delete(task)
            
            do{
                try context.save()
            }catch{
                print("Error Deleting Task \(error)")
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        tasksList.reloadData()
    }
  
    func showInputDialog() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default) { (action) in
            
            let newTask = ToDoEntity(context: self.context)
            newTask.name = textField.text!
            self.tasks.append(newTask)
            self.saveTasks()
        }
        
        alert.addAction(action)
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a New Todo Task"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveTasks(){
        do{
            try context.save()
        }catch{
            print("Error Saving Task")
        }
        tableView.reloadData()
    }
    
    func loadTasks(){
        
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        
        do{
            tasks = try context.fetch(request)
        }catch{
            print("Error fetching tasks \(error)")
        }
        
        tableView.reloadData()
    }
}
