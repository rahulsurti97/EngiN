//
//  ProjectMenuTableViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 12/2/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit


class ProjectMenuTableViewController: UITableViewController, EntryDelegate, TeamMemberDelegate {

    var project: Project?
    
    var delegate: EntryDelegate?
    var memberDelegate: TeamMemberDelegate?
    
    @IBOutlet weak var entryCount: UILabel!
    @IBOutlet weak var recentEntryDate: UILabel!
    @IBOutlet weak var numberOfTeamMembers: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    // Sets labels of cell in Entries Section
    func configureView() {
        if let p = project as Project? {
            let count = p.projectEntries.count
            if count == 1 { entryCount.text = "\(count) Entry" }
            else          { entryCount.text = "\(count) Entries" }
            recentEntryDate.text = p.projectEntries.first?.entryDate
            numberOfTeamMembers.text = "\(p.projectMembers.count) Members"
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Disable toolbar.
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    // Sets section headers
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return project?.projectTitle }
        else            { return "Options" }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Sets ProjectTableViewController to show the specific project selected by the user
        if segue.identifier == "showProject" {
            // Sets delegate, project and title of Project Table View.
            if let c = (segue.destinationViewController as? ProjectTableViewController) {
                c.delegate = self
                c.projectItem = project
                c.navigationItem.title = project!.projectTitle
            }
        }
        if segue.identifier == "showTeamMembers" {
            if let c = segue.destinationViewController as? TeamMemberTableViewController {
                c.delegate = self
                c.members = (project?.projectMembers)!
                c.navigationItem.title = project!.projectTitle
            }
        }
        /*if segue.identifier == "showProjectDescription" {
            if let c = segue.destinationViewController as? ProjectDescriptionViewController {

            }
        }*/
        
    }
    
    // Calls delegate in library method to update entries at scope of Library.
    func updateEntry(controller: ProjectTableViewController, newEntry: Entry, atProject: Project, type: Int) -> Project {
        // Set project to updated project and refresh the labels.
        project = delegate?.updateEntry(controller, newEntry: newEntry, atProject: atProject, type: type)
        configureView()
        return project!
    }
    
    func updateTeamMembers(controller: TeamMemberTableViewController, teamMembers: [Member], atProject: String) -> [Member] {
        project?.projectMembers = (memberDelegate?.updateTeamMembers(controller, teamMembers: teamMembers, atProject: atProject))!
        configureView()
        return (project?.projectMembers)!
    }
}
