//
//  EntryTableCell.swift
//  Master Detail
//
//  Created by Rahul Surti on 11/11/15.
//  Copyright © 2015 rahulsurti. All rights reserved.
//

import UIKit

class DateTableCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
}
