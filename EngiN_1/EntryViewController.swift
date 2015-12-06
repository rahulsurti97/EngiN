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
    
    var originalText: String = ""
    
    var entryDelegate: EntryChangedDelegate?
    
    var entryItem: Entry? {
        // Update View if set.
        didSet { self.configureView() }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        self.detailDescriptionLabel?.text = self.entryItem?.entryText
        originalText = (self.entryItem?.entryText)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        save()
    }
    
    func edit() {
        self.detailDescriptionLabel.editable = true
        let saveButton = UIBarButtonItem(title: "Save", style: .Done, target: self, action: "save")
        self.tabBarController?.navigationItem.setRightBarButtonItem(saveButton, animated: true)
        self.tabBarController?.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
    }
    
    func save() {
        self.detailDescriptionLabel.editable = false
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit , target: self, action: "edit")
        self.tabBarController?.navigationItem.setRightBarButtonItem(editButton, animated: true)
        originalText = detailDescriptionLabel.text
    }
    
    override func viewWillDisappear(animated: Bool) {
        entryItem?.entryText = originalText
        entryDelegate?.updateEntryText(self, entry: entryItem!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}