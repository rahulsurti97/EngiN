//
//  ProjectTableViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 11/24/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit

protocol EntryDelegate {
    func updateEntry(controller: ProjectTableViewController, newEntry: Entry, atProject: Project, type: Int) -> Project
}
class ProjectTableViewController: UITableViewController {

    var entries = [AnyObject]()
    
    var delegate: EntryDelegate?
    
    var projectItem: Project? {
        // Update View if set.
        didSet { self.configureView() }
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
        
        // Creates add button in top right of navigation bar.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForTitle")
        
        // Enables toolbar and adds edit button in bottom left.
        self.setToolbarItems([self.editButtonItem()], animated: true)
        
        // Update View
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
        
        // Prompts user to create a different title if the title was previously used.
        if firstAttempt { alert = UIAlertController(title: "Enter A Title", message: "", preferredStyle: .Alert) }
        else            { alert = UIAlertController(title: "Please enter a different title", message: "This title is already used.", preferredStyle: .Alert) }
        
        // Add the text field.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in textField.text = "" })
        
        // Do not remove entry if user hits "Cancel"
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in /*Do nothing*/ }))
        
        // Grab the value from the text field, and create project with title when the user hits "Create".
        alert.addAction(UIAlertAction(title: "Create", style: .Default, handler: { (action) -> Void in
            // Creates text field and saves input.
            let textField = alert.textFields![0] as UITextField
            let myEntryTitle = textField.text!
            
            // Determines if title is valid, ie. not previously used.
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
            
            // Insert entry and reset firstAttempt if title is valid, prompt again and set firstAttempt to false if invalid.
            self.firstAttempt = titleIsOK
            if titleIsOK { self.insertNewEntry(myEntryTitle) }
            else         { self.promptForTitle() }
        }))

        // Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func insertNewEntry(myEntryTitle: String) {
        // Creates Entry object.
        let myEntry = Entry(title: myEntryTitle, date: currentDate(), text: "Sample Text")
        
        // Inserts entry in the entries array.
        entries.insert(myEntry, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)

        // Inserts the entry into the project at the scope of the library.
        if let delegate = self.delegate {
            if let project = self.projectItem {
                delegate.updateEntry(self, newEntry: myEntry, atProject: project, type: 0)
            }
        }
    }
    
    // Creates a String for the current date.
    func currentDate() -> String {
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.stringFromDate(todaysDate)
    }
    
    // MARK: - Table view data source

    // There must only be 1 section in Library.
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows must be equal to number of projects.
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }

    // Manages each cell in table.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "DateCell")
        
        let entry = entries[indexPath.row] as! Entry
        cell.textLabel?.text = entry.entryTitle
        cell.detailTextLabel?.text = entry.entryDate
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    // Segues to Entry when user selects row.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showEntry", sender: UITableViewCell.self)
    }
    
    // Allows user to delete entries.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // Allows user to delete entries from project.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Prompts user to confirm removal of entry.
            let alert = UIAlertController(title: "Are you sure you want to delete this entry?", message: "This action cannot be undone", preferredStyle: .Alert)
            
            // Do not remove entry if user hits "Cancel".
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in /* Do nothing */  }))
            
            // Delete entry if user hits "Delete".
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action) -> Void in
                // Removes the entry of the project at the scope of the library.
                if let delegate = self.delegate {
                    if let project = self.projectItem {
                        let entry = self.entries[indexPath.row] as! Entry
                        delegate.updateEntry(self, newEntry: entry, atProject: project, type: 1)
                    }
                }
                self.entries.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Present the alert.
            self.presentViewController(alert, animated: true, completion: nil)
        } else if editingStyle == .Insert { /* Managed elsewhere */ }
    }

    // Sets title of section.
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Entries"
    }
    
    // MARK: - Navigation

    // Passes entry properties to Entry.
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