//
//  ProjectDescriptionViewController.swift
//  EngiN_1
//
//  Created by Rahul Surti on 12/4/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit

protocol ProjectDescriptionDelegate {
    func updateProjectDescription(controller: ProjectDescriptionViewController, atProject: Project) -> Project
}
class ProjectDescriptionViewController: UIViewController {
    
    @IBOutlet weak var detailDescriptionLabel: UITextView!
    
    var originalText: String = ""
    
    var delegate: ProjectDescriptionDelegate?
    
    var projectItem: Project? {
        // Update View if set.
        didSet { self.configureView() }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        self.detailDescriptionLabel?.text = self.projectItem?.projectDescription
        originalText = (self.projectItem?.projectDescription)!
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
        self.navigationItem.setRightBarButtonItem(saveButton, animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.redColor()
    }
    
    func save() {
        self.detailDescriptionLabel.editable = false
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit , target: self, action: "edit")
        self.navigationItem.setRightBarButtonItem(editButton, animated: true)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.blueColor()
        originalText = detailDescriptionLabel.text
    }
    
    override func viewWillDisappear(animated: Bool) {
        projectItem?.projectDescription = originalText
        projectItem = delegate?.updateProjectDescription(self, atProject: projectItem!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
