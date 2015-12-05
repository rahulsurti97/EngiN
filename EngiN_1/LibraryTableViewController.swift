//
//  LibraryTableViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 11/24/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit

class LibraryTableViewController: UITableViewController, EntryDelegate, TeamMemberDelegate {
    
    var projects = [AnyObject]()
    
    var first: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        
        // Adds edit button in top right.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Sets add button in bottom right of toolbar.
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add , target: self, action: "promptForTitle")
        let flexButtonItem = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: "")
        self.setToolbarItems([flexButtonItem, addButton], animated: false)
        
        // Upon first opening app, creates a sample project.
        insertNewProject("EngiN")
        first = false
    }
    
    override func viewDidAppear(animated: Bool) {
        // Enable toolbar.
        self.navigationController?.setToolbarHidden(false, animated: true)
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

        // Do not remove project if user hits "Cancel".
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in /* Do nothing */ }))
        
        // Grab the value from the text field, and create project with title when the user hits "Create".
        alert.addAction(UIAlertAction(title: "Create", style: .Default, handler: { (action) -> Void in
            // Creates text field and saves input.
            let textField = alert.textFields![0] as UITextField
            let myProjectTitle = textField.text!
            
            // Determines if title is valid, ie. not previously used.
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
            
            // Insert project and reset firstAttempt if title is valid, prompt again and set firstAttempt to false if invalid.
            self.firstAttempt = titleIsOK
            if titleIsOK { self.insertNewProject(myProjectTitle) }
            else         { self.promptForTitle() }
        }))
        
        // Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func insertNewProject(myProjectTitle: String) {
        // Creates new project; if first opening app, create a sample project.
        var myEntries: [Entry] = []
        var myMembers: [Member] = []
        if first {
            myMembers = [Member(name: "Rahul", role: "Captain", bio: ""), Member(name: "Kevin", role: "Manager", bio: ""), Member(name: "Kanyon", role: "Programmer",bio: "")]
            myEntries = [Entry(title: "First Entry", date: currentDate(), text: "This is our project!", members: myMembers)]
        }
        let project = Project(title: myProjectTitle, date: currentDate(), entries: myEntries, members: myMembers)
        
        // Inserts project in the projects array.
        projects.append(project)
        let indexPath = NSIndexPath(forRow: projects.count - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
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
        return projects.count
    }
    
    // Manages each cell in table.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Creates cell with custom reuseIdentifier.
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "DateCell")
        
        // Sets properties of cell depending on project properties.
        let project = projects[indexPath.row] as! Project
        cell.textLabel?.text = project.projectTitle
        cell.detailTextLabel?.text = project.projectDate
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    // Segues to Project Menu when user selects row.
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("showProjectMenu", sender: UITableViewCell.self)
    }
    
    // Allows user to delete projects.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Allows user to delete projects from project array.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Prompts user to confirm removal of project.
            let alert = UIAlertController(title: "Are you sure you want to delete this project?", message: "This action cannot be undone", preferredStyle: .Alert)
            
            // Do not remove project if user hits "Cancel".
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in /* Do nothing */  }))
            
            // Delete project if user hits "Delete".
            alert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action) -> Void in
                self.projects.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            }))
            
            // Present the alert.
            self.presentViewController(alert, animated: true, completion: nil)
        } else if editingStyle == .Insert { /* Managed elsewhere */ }
    }
    
    // Sets title of section.
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Projects"
    }
    
    
    // MARK: - Navigation
    
    // Passes project properties to Project Menu.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showProjectMenu" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                // Sets delegate, project, and title of Project Menu.
                if let c = (segue.destinationViewController as? ProjectMenuTableViewController) {
                    c.delegate = self
                    c.memberDelegate = self
                    c.project = (projects[indexPath.row] as! Project)
                    c.navigationItem.title = "Home"
                }
            }
        }
    }
    
    // Updates entry to specified project in projects array.
    func updateEntry(controller: ProjectTableViewController, newEntry: Entry, atProject: Project, type: Int) -> Project {
        var projectToReturn: Project = Project()
        // Find correct project to modify
        for project in self.projects {
            if let p = (project as? Project) {
                if atProject.projectTitle == p.projectTitle {
                    // Gets project to return; used to set labels in Entries section of Project Menu
                    projectToReturn = p
                    
                    // Depending on if user added, deleted, or modified entry, update specified entry
                    switch type {
                    case 2: //Update Entry
                        for var i = 0; i < p.projectEntries.count; i++ {
                            if newEntry.entryTitle == p.projectEntries[i].entryTitle { p.projectEntries[i] = newEntry }
                        }
                    case 1: //Remove Entry
                        for var i = 0; i < p.projectEntries.count; i++ {
                            if newEntry.entryTitle == p.projectEntries[i].entryTitle { p.projectEntries.removeAtIndex(i) }
                        }
                    default://Add Entry
                            p.projectEntries.append(newEntry)
                    }
                }
            }
        }
        return projectToReturn
    }
    
    func updateTeamMembers(controller: TeamMemberTableViewController, atProject: Project) -> Project {
        // Find correct project to modify
        for project in self.projects {
            if let p = (project as? Project) {
                if atProject.projectTitle == p.projectTitle {
                    p.projectMembers = atProject.projectMembers
                }
            }
        }
        return atProject
    }
}
