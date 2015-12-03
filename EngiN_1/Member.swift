//
//  Contact.swift
//  EngiN_1
//
//  Created by Rahul Surti on 12/2/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import Foundation
import UIKit

class Member {
    var memberName: String
    var memberRole: String
    var memberBio: String
    
    init(name: String, role: String, bio: String) {
        memberName = name
        memberRole = role
        memberBio = bio
    }
}