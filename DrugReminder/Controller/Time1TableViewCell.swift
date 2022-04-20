//
//  Time1TableViewCell.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/19.
//

import UIKit

class Time1TableViewCell: UITableViewCell {
    
    @IBOutlet var time1Label: UILabel!
    
    static let identifier = "Time1TableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "Time1TableViewCell", bundle: nil)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
