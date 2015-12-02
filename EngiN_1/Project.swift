//
//  Project.swift
//  EngiN_1
//
//  Created by Rahul Surti on 11/24/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import Foundation
import UIKit

class Project {
    var projectTitle: String
    var projectDate: String
    var projectEntries: [Entry]
    
    init(title: String, date: String, entries: [Entry]) {
        projectTitle = title
        projectDate = date
        projectEntries = entries
    }
    init() {
        projectTitle = ""
        projectDate = ""
        projectEntries = []
    }
}