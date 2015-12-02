//
//  LibraryTableViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 11/24/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController, EntryDelegate {
    
    var projects = [AnyObject]()
    
    //weak var delegate: ProjectSelectionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Library"
        self.clearsSelectionOnViewWillAppear = true
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForTitle")
        self.navigationItem.rightBarButtonItem = addButton
        //tableView.registerNib(UINib(nibName: "DateTableViewCell", bundle: nil), forCellReuseIdentifier: "DateCell")
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "DateCell")
        self.navigationController?.toolbarHidden = false
        //self.navigationController?.setToolbarItems([addButton], animated: true)
        //let settingsButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: "")
        
        
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
            let myProjectTitle = textField.text!
            
            // Closure returns Bool, represents if title entered by user is not previously used.
            let titleIsOK: Bool = {() -> Bool in
                for project in self.projects {
                    if let projTitle = (project as? Project)?.projectTitle {
                        if myProjectTitle == projTitle {
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
                self.insertNewProject(myProjectTitle)
            case false:
                self.firstAttempt = false
                self.promptForTitle()
            }
        }))
        
        // Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func insertNewProject(myProjectTitle: String) {
        // Creates Project object
        let project = Project()
        
        // Sets project's projectTitle variable to title entered by user
        project.projectTitle = myProjectTitle
        
        // Sets project's projectDate variable to current date
        let todaysDate:NSDate = NSDate()
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        project.projectDate = dateInFormat
        
        // Inserts project in the projects array
        projects.insert(project, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        //NSUserDefaults.standardUserDefaults().setValue(projects, forKey: "library")
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    // Instantiates cells to show all projects in the project array
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "DateCell")
        
        let project = projects[indexPath.row] as! Project
        cell.textLabel?.text = project.projectTitle
        cell.detailTextLabel?.text = project.projectDate
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator

        return cell
    }
    
    // Segues to ProjectTableViewController when user selects row
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showProject", sender: UITableViewCell.self)
    }
    
    // Allows user to delete projects
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Allows user to delete projects from project array
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Prompts user to confirm removal of project
            let alert = UIAlertController(title: "Are you sure you want to delete this project?", message: "This action cannot be undone", preferredStyle: .Alert)
            
            // Do not remove project if user hits "Cancel"
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                // Do nothing
            }))
            
            // Delete project if user hits "Delete".
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action) -> Void in
                self.projects.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                //NSUserDefaults.standardUserDefaults().setValue(self.projects, forKey: "library")
            }))
            
            // Present the alert.
            self.presentViewController(alert, animated: true, completion: nil)
        } else if editingStyle == .Insert {
            // Create a new instance of project, insert it into the array, and add a new row to the table view.
        }
    }
    
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Sets ProjectTableViewController to show the specific project selected by the user
        if segue.identifier == "showProject" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // Gets project from project array
                let project = projects[indexPath.row] as! Project
                
                // Gets ProjectTableViewController and sets properties
                let controller = segue.destinationViewController as? ProjectTableViewController
                if let c = controller {
                    c.delegate = self
                }
                controller!.projectItem = project
                controller!.navigationItem.title = project.projectTitle
            }
        }
    }
    
    // Inserts new entry to correct project in projects array
    func addEntry(controller: ProjectTableViewController, didAddEntry: Entry, toProject: String) {
        for project in self.projects {
            if let p = (project as? Project) {
                if toProject == p.projectTitle {
                    p.projectEntries.insert(didAddEntry, atIndex: 0)
                }
            }
        }
    }
    
    // Removes correct entry at correct project in projects array
    func removeEntry(controller: ProjectTableViewController, didRemoveEntry: String, atProject: String) {
        for project in self.projects {
            if let p = (project as? Project) {
                if atProject == p.projectTitle {
                    for var i = 0; i < p.projectEntries.count; i++ {
                        if didRemoveEntry == p.projectEntries[i].entryTitle {
                            p.projectEntries.removeAtIndex(i)
                        }
                    }
                }
            }
        }
    }
    
    // Updates correct entry to correct project in projects array
    func updateEntry(controller: ProjectTableViewController, didUpdateEntry: Entry, atProject: String) {
        for project in self.projects {
            if let p = (project as? Project) {
                if atProject == p.projectTitle {
                    for var i = 0; i < p.projectEntries.count; i++ {
                        if didUpdateEntry.entryTitle == p.projectEntries[i].entryTitle {
                            p.projectEntries[i] = didUpdateEntry
                        }
                    }
                }
            }
        }
    }
}
