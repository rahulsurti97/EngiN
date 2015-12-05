//
//  EntryViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 11/24/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit

protocol EntryChangedDelegate {
    func updateEntryText(controller: EntryViewController, entry: Entry) -> Entry
}
class EntryViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UITextView!
    
    var entryDelegate: EntryChangedDelegate?
    
    var entryItem: Entry? {
        // Update View if set.
        didSet { self.configureView() }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let entry = self.entryItem {
            if let label = self.detailDescriptionLabel {
                label.text = entry.entryText
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.navigationController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "My Back Button", style: .Plain, target: self, action: "")
    }
    
    func back() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        save()
    }
    
    func edit() {
        self.detailDescriptionLabel.editable = true
        let saveButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: "save")
        self.tabBarController?.navigationItem.setRightBarButtonItem(saveButton, animated: true)
    }
    
    func save() {
        self.detailDescriptionLabel.editable = false
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit , target: self, action: "edit")
        self.tabBarController?.navigationItem.setRightBarButtonItem(editButton, animated: true)
    }
    
    /*override func viewWillDisappear(animated: Bool) {
        entryItem?.entryText = detailDescriptionLabel.text
        entryDelegate?.updateEntryText(self, entry: entryItem!)
    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}