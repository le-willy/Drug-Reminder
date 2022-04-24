//
//  NotificationSwitchTableViewCell.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/23.
//

import UIKit

class NotificationSwitchTableViewCell: UITableViewCell {
    
    static let indentifier = "NotificationSwitchTableViewCell"
    
    static func uinib() -> UINib {
        return UINib(nibName: "NotificationSwitchTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var notificationLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        notificationLabel.text = "通知on/off"
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
