//
//  Time1TableViewCell.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/15.
//

import UIKit

class Time1TableViewCell: UITableViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dosesLabel: UILabel!
    @IBOutlet weak var checkmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
