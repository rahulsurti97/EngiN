//
//  Entry.swift
//  EngiN_1
//
//  Created by Rahul Surti on 11/24/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import Foundation
import UIKit

class Entry {
    var entryTitle: String
    var entryText: String
    var entryDate: String
    
    init(title: String, date: String, text: String){
        entryTitle = title
        entryDate = date
        entryText = text
    }
}