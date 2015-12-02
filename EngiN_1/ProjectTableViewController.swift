//
//  ProjectTableViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 11/24/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit

protocol EntryDelegate {
    func addEntry(controller: ProjectTableViewController, didAddEntry: Entry, toProject: String)
    func removeEntry(controller: ProjectTableViewController, didRemoveEntry: String, atProject: String)
    func updateEntry(controller: ProjectTableViewController, didUpdateEntry: Entry, atProject: String)
}

class ProjectTableViewController: UITableViewController {

    var entries = [AnyObject]()
    
    var delegate: EntryDelegate?
    
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
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DateCell")
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
        
        // Do not remove project if user hits "Cancel"
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            // Do nothing
        }))
        
        // Grab the value from the text field, and create project with title when the user hits "Create".
        alert.addAction(UIAlertAction(title: "Create", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            let myEntryTitle = textField.text!
            
            // Closure returns Bool, represents if title entered by user is not previously used.
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
        // Creates Entry object.
        let myEntry = Entry()
        
        // Sets entry's entryTitle variable to title entered by user.
        myEntry.entryTitle = myEntryTitle
        
        // Sets entry's entryDate variable to current date.
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        myEntry.entryDate = dateInFormat
        
        // Inserts entry in the entries array.
        entries.insert(myEntry, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

        // Inserts the entry into the project at the scope of the library.
        if let delegate = self.delegate {
            if let project = self.projectItem {
                delegate.addEntry(self, didAddEntry: myEntry, toProject: project.projectTitle)
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    // Instantiates cells to show all entries in the project.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "DateCell")
        let entry = entries[indexPath.row] as! Entry
        cell.textLabel?.text = entry.entryTitle
        cell.detailTextLabel?.text = entry.entryDate
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    // Allows user to delete entries.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showEntry", sender: UITableViewCell.self)
    }

    // Allows user to delete entries from project.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Prompts user to confirm removal of entry.
            let alert = UIAlertController(title: "Are you sure you want to delete this entry?", message: "This action cannot be undone", preferredStyle: .Alert)
            
            // Do not remove entry if user hits "Cancel".
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                // Do nothing
            }))
            
            // Delete entry if user hits "Delete".
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action) -> Void in
                // Removes the entry of the project at the scope of the library.
                if let delegate = self.delegate {
                    if let project = self.projectItem {
                        let entry = self.entries[indexPath.row] as! Entry
                        delegate.removeEntry(self, didRemoveEntry: entry.entryTitle, atProject: project.projectTitle)
                    }
                }
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
        // Sets DetailViewController to show the specific entry selected by the user.
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