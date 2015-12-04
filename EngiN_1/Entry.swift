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
    var membersPresent = [(member: Member, present: Bool)]()
    
    init(title: String, date: String, text: String, members: [Member]){
        entryTitle = title
        entryDate = date
        entryText = text
        for var i = 0; i < members.count; i++ {
            membersPresent.append((member: members[i], present: false))
        }
    }
    
    func togglePresent(member: Member, present: Bool) {
        for var i = 0; i < membersPresent.count; i++ {
            var m = membersPresent[i]
            if member.memberName == m.member.memberName {
                m.present = present
            }
        }
    }
}