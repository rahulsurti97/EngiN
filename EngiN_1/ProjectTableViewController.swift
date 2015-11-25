//
//  ProjectTableViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 11/24/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit

class ProjectTableViewController: UITableViewController {

    var entries = [AnyObject]()
    
    var projectItem: Project? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the project item.
        if let project = self.projectItem {
            entries = project.projectEntries
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForTitle")
        self.navigationItem.rightBarButtonItem = addButton
        tableView.registerNib(UINib(nibName: "DateTableViewCell", bundle: nil), forCellReuseIdentifier: "DateCell")
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private var firstAttempt = true
    func promptForTitle(){
        // Create the alert controller.
        let alert: UIAlertController
        
        switch firstAttempt {
        case true:
            alert = UIAlertController(title: "Enter A Title", message: "", preferredStyle: .Alert)
        case false:
            alert = UIAlertController(title: "Please enter a different title", message: "This title is already used.", preferredStyle: .Alert)
        }
        
        // Add the text field.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        // Grab the value from the text field, and create project with title when the user hits "Create".
        alert.addAction(UIAlertAction(title: "Create", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let myEntryTitle = textField.text!
            
            // Trailing closure returns Bool, represents if title entered by user is not previously used.
            let titleIsOK: Bool = {() -> Bool in
                for entry in self.entries {
                    if let entTitle = (entry as? Entry)?.entryTitle {
                        if myEntryTitle == entTitle {
                            return false
                        }
                    }
                }
                return true
            }()
            
            // Switch for Bool titleIsOK, insert object if true, prompt again if false.
            switch titleIsOK {
            case true:
                self.firstAttempt = true
                self.insertNewEntry(myEntryTitle)
            case false:
                self.firstAttempt = false
                self.promptForTitle()
            }
        }))

        
        // Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    
    func insertNewEntry(myEntryTitle: String) {
        // Creates Entry object
        let entry = Entry()
        
        // Sets entry's entryTitle variable to title entered by user
        entry.entryTitle = myEntryTitle
        
        // Sets entry's entryDate variable to current date
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        entry.entryDate = dateInFormat
        
        // Inserts entry in the entries array
        entries.insert(entry, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    // Instantiates cells to show all entries in the project
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("DateCell", forIndexPath: indexPath) as! DateTableCell
        
        let entry = entries[indexPath.row] as! Entry
        cell.titleLabel!.text = entry.entryTitle
        cell.dateLabel!.text = entry.entryDate
        return cell
    }

    // Allows user to delete entries
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showEntry", sender: UITableViewCell.self)
    }

    // Allows user to delete entries from project
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Prompts user to confirm removal of entry
            let alert = UIAlertController(title: "Are you sure you want to delete this entry?", message: "This action cannot be undone", preferredStyle: .Alert)
            
            // Do not remove entry if user hits "Cancel"
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                // Do nothing
            }))
            
            // Delete entry if user hits "Delete".
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action) -> Void in
                self.entries.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Present the alert.
            self.presentViewController(alert, animated: true, completion: nil)
        } else if editingStyle == .Insert {
            // Create a new instance of entry, insert it into the array, and add a new row to the table view.
        }
    }

    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Sets DetailViewController to show the specific entry selected by the user
        if segue.identifier == "showEntry" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // Gets entry from entry array
                let entry = entries[indexPath.row] as! Entry
                
                // Gets EntryViewController and sets properties
                let controller = segue.destinationViewController as! EntryViewController
                controller.detailItem = entry
                controller.navigationItem.title = entry.entryTitle
            }
        }
    }
}
/*extension ProjectTableViewController: ProjectSelectionDelegate {
    func projectSelected(newProject: Project) {
        entries = newProject.projectEntries
    }
}*/
