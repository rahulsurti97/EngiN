//
//  ProjectMenuTableViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 12/2/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit


class ProjectMenuTableViewController: UITableViewController, EntryDelegate {

    var project: Project?
    
    var delegate: EntryDelegate?
    
    @IBOutlet weak var entryCount: UILabel!
    @IBOutlet weak var recentEntryDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let p = project as Project? {
            let count = p.projectEntries.count
            if count == 1 { entryCount.text = "\(count) Entry" }
            else          { entryCount.text = "\(count) Entries" }
            recentEntryDate.text = p.projectEntries.first?.entryDate
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: return 1
        default: return 2
        }
    }*/

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    
    /*// Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }*/

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Sets ProjectTableViewController to show the specific project selected by the user
        if segue.identifier == "showProject" {
            // Gets project from project array
            
            // Gets ProjectTableViewController and sets properties
            let controller = segue.destinationViewController as? ProjectTableViewController
            if let c = controller {
                c.delegate = self
            }
            controller!.projectItem = project
            let p = project! as Project
            controller!.navigationItem.title = p.projectTitle
        }
    }
    
    func updateEntry(controller: ProjectTableViewController, newEntry: Entry, atProject: String, type: Int) {
        delegate?.updateEntry(controller, newEntry: newEntry, atProject: atProject, type: type)
    }
    
    func getEntries(controller: ProjectTableViewController, atProject: String) -> [Entry] {
        return (delegate?.getEntries(controller, atProject: atProject))!
    }
}
