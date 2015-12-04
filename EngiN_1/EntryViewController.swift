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
    }
    
    override func viewWillDisappear(animated: Bool) {
        entryItem?.entryText = detailDescriptionLabel.text
        entryDelegate?.updateEntryText(self, entry: entryItem!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}