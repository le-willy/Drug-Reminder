//
//  Time3TableViewCell.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/20.
//

import UIKit

class Time3TableViewCell: UITableViewCell {
    
    @IBOutlet var time3Label: UILabel!
    
    static let identifier = "Time3TableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "Time3TableViewCell", bundle: nil)
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
