//
//  EntryTeamMemberTableViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 12/3/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit

protocol MemberPresentDelegate {
    func updatePresent(controller: EntryTeamMemberTableViewController, members: [(member: Member, present: Bool)]) -> [(member: Member, present: Bool)]
}
class EntryTeamMemberTableViewController: UITableViewController {

    var originalMembers = [(member: Member, present: Bool)]()
    
    var teamMembers = [(member: Member, present: Bool)]()
    
    var presentDelegate: MemberPresentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(animated: Bool) {
        save()
    }
    
    override func viewWillDisappear(animated: Bool) {
        teamMembers = (presentDelegate?.updatePresent(self, members: originalMembers))!
    }
    
    var editable: Bool = false
    func edit() {
        editable = true
        let saveButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: "save")
        self.tabBarController?.navigationItem.setRightBarButtonItem(saveButton, animated: true)
        self.tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
    }
    
    func save() {
        editable = false
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit , target: self, action: "edit")
        self.tabBarController?.navigationItem.setRightBarButtonItem(editButton, animated: true)
        originalMembers = teamMembers
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMembers.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamMember", forIndexPath: indexPath)
        let tuple = teamMembers[indexPath.row]
        cell.textLabel?.text = tuple.member.memberName
        cell.detailTextLabel?.text = tuple.member.memberRole
        if tuple.present {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark }
        else { cell.accessoryType = UITableViewCellAccessoryType.None }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if editable {
            teamMembers[indexPath.row].present = !teamMembers[indexPath.row].present
            if self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == UITableViewCellAccessoryType.None {
                self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
            else {
                self.tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
            }
        }
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
