//
//  EntryTabBarViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 12/3/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit

protocol EntryModifiedDelegate {
    func updateEntry(controller: EntryTabBarViewController, modifiedEntry: Entry) -> Entry
}
class EntryTabBarViewController: UITabBarController, MemberPresentDelegate, EntryChangedDelegate{
    
    var entryItem: Entry?
    
    var entryDelegate: EntryModifiedDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let teamMemberVC = self.viewControllers![0] as! EntryTeamMemberTableViewController
        teamMemberVC.teamMembers = (entryItem?.membersPresent)!
        teamMemberVC.presentDelegate = self
        
        let entryVC = self.viewControllers![self.viewControllers!.count-1] as! EntryViewController
        entryVC.entryItem = self.entryItem
        entryVC.entryDelegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updatePresent(controller: EntryTeamMemberTableViewController, members: [(member: Member, present: Bool)]) -> [(member: Member, present: Bool)]{
        entryItem?.membersPresent = members
        entryItem = entryDelegate?.updateEntry(self, modifiedEntry: entryItem!)
        return members
    }
    
    func updateEntryText(controller: EntryViewController, entry: Entry) -> Entry {
        entryItem = entryDelegate?.updateEntry(self, modifiedEntry: entry)
        return entry
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
