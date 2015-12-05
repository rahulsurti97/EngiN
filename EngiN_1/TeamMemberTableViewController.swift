//
//  TeamMemberTableViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 12/2/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit
protocol TeamMemberDelegate {
    func updateTeamMembers(controller: TeamMemberTableViewController, atProject: Project) -> Project
}
protocol ProjectDelegate {
    func updateProject(controller: TeamMemberTableViewController, project: Project) -> Project
}
class TeamMemberTableViewController: UITableViewController {

    var projectItem: Project?
    
    var delegate: TeamMemberDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        
        // Creates add button in top right of navigation bar.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "promptForName")
        
        // Enables toolbar and adds edit button in bottom left.
        self.setToolbarItems([self.editButtonItem()], animated: true)
    }
    
    private var firstAttempt = true
    func promptForName(){
        // Create the alert controller.
        let alert: UIAlertController
        
        // Prompts user to change a team member name if the name was previously used.
        if firstAttempt { alert = UIAlertController(title: "Add Team Member", message: "", preferredStyle: .Alert) }
        else            { alert = UIAlertController(title: "Please enter a different name", message: "Team members' names cannot be exactly the same.", preferredStyle: .Alert) }
        
        // Add name text field.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in textField.placeholder = "Name" })
        // Add role text field.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in textField.placeholder = "Role" })
        
        // Do not add member if user hits "Cancel"
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in /*Do nothing*/ }))
        
        // Grab the value from the text fields, and add member with name and role when the user hits "Add".
        alert.addAction(UIAlertAction(title: "Add", style: .Default, handler: { (action) -> Void in
            // Creates text field and saves input.
            let textField = alert.textFields![0] as UITextField
            let memberName = textField.text!
            
            let roleTextField = alert.textFields![1] as UITextField
            let role = roleTextField.text!
            
            // Determines if name is valid, ie. not previously used.
            let nameIsOK: Bool = {() -> Bool in
                for m in (self.projectItem?.projectMembers)! {
                    if m.memberName == memberName {
                        return false
                    }
                }
                return true
            }()
            
            // Insert member and reset firstAttempt if name is valid, prompt again and set firstAttempt to false if invalid.
            self.firstAttempt = nameIsOK
            if nameIsOK { self.insertNewMember(memberName, role: role) }
            else        { self.promptForName() }

        }))
        
        // Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func insertNewMember(memberName: String, role: String) {
        // Inserts member in the members array.
        projectItem?.projectMembers.append(Member(name: memberName, role: role, bio: ""))
        let indexPath = NSIndexPath(forRow: (projectItem?.projectMembers.count)! - 1, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        self.delegate!.updateTeamMembers(self, atProject: self.projectItem!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (projectItem?.projectMembers.count)!
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamMember", forIndexPath: indexPath)
        if let members = projectItem?.projectMembers {
            cell.textLabel?.text = members[indexPath.row].memberName
            cell.detailTextLabel?.text = members[indexPath.row].memberRole
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    // Allows user to remove members from project.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Prompts user to confirm removal of entry.
            let alert = UIAlertController(title: "Are you sure you want to remove this team member?", message: "This will remove him/her from all future entries", preferredStyle: .Alert)
            
            // Do not remove member if user hits "Cancel".
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in /* Do nothing */  }))
            
            // Remove member if user hits "Delete".
            alert.addAction(UIAlertAction(title: "Remove", style: .Default, handler: { (action) -> Void in
                // Removes the entry of the project at the scope of the library.
                self.projectItem?.projectMembers.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                self.delegate?.updateTeamMembers(self, atProject: self.projectItem!)
            }))
            
            // Present the alert.
            self.presentViewController(alert, animated: true, completion: nil)
        } else if editingStyle == .Insert {
            // Create a new instance of entry, insert it into the array, and add a new row to the table view.
        }
    }
    
    // Sets title of section.
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Team Members"
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
