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

class RootViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    var tasks: [NSManagedObject] = []
    
    @IBOutlet weak var tasksList: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchData = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        
        do
        {
            tasks = try context.fetch(fetchData)
        }
        catch
        {
            print("Error loading the data")
        }
    }
    
 
    
    var titleTextField: UITextField!
    var descriptionTextField: UITextField!
    
    func titleTextField(textfield: UITextField!)
    {
        titleTextField = textfield
        titleTextField.placeholder = "Add Title"
    }
    
    func descriptionTextField(textfield: UITextField!)
    {
        descriptionTextField = textfield
        descriptionTextField.placeholder = "Add Description"
    }

    

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//        var t = self.tasks[indexPath.row]
//        t.completed = !t.completed
//        saveTasks
//    }

    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {

//        let finished = UITableViewRowAction(style: .normal, title: "Mark Finished") { action, indexPath in
//            //print("more button tapped")
//            self.tasksList.deselectRow(at: indexPath, animated: true)
//
//            var t = self.tasks[indexPath.row]
//            t.completed = !t.completed
//            self.saveTasks(alert: UIAlertAction)
//        }
//        finished.backgroundColor = .lightGray

        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, indexPath in
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext

            context.delete(self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row)

            do
            {
                try context.save()
            }
            catch
            {
                print("Error occured while deleting!")
            }
            self.tasksList.reloadData()
        }
        delete.backgroundColor = .red

        return [delete]
    }


    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

   
    
    @IBAction func addNewTask(_ sender: UIBarButtonItem)
    {
        let alert = UIAlertController(title: "Add Task", message: "Add New Task Below", preferredStyle: .alert)
        let action = UIAlertAction(title: "Save", style: .default, handler: self.saveTasks)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(action)
        alert.addAction(cancelAction)
        
        alert.addTextField(configurationHandler: titleTextField)
        alert.addTextField(configurationHandler: descriptionTextField)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTasks(alert: UIAlertAction)
    {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Entity", in: context)!
        
            let theTitle = NSManagedObject(entity: entity, insertInto: context)
            theTitle.setValue(titleTextField.text, forKey: "name")
        
            let theDesc = NSManagedObject(entity: entity, insertInto: context)
            theDesc.setValue(descriptionTextField.text, forKey: "notes")
        
            do
            {
                try context.save()
                tasks.append(theTitle)
                tasks.append(theDesc)
            }
            catch
            {
                print("Error occured while saving")
            }
            self.tasksList.reloadData()
    }
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
//    {
//        if editingStyle == UITableViewCellEditingStyle.delete
//        {
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//            let context = appDelegate.persistentContainer.viewContext
//
//            context.delete(tasks[indexPath.row])
//            tasks.remove(at: indexPath.row)
//
//            do
//            {
//                try context.save()
//            }
//            catch
//            {
//                print("Error occured while deleting!")
//            }
//            self.tasksList.reloadData()
//        }
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //return (list.count)
        return (tasks.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let title = tasks[indexPath.row]
        let cell = tasksList.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = title.value(forKey: "name") as? String
        cell.detailTextLabel?.text = title.value(forKey: "notes") as? String
        return cell
    }
}
