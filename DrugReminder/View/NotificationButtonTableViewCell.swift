//
//  NotificationButtonTableViewCell.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/05/19.
//

import UIKit

class NotificationButtonTableViewCell: UITableViewCell {
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        onOffSwitch.isOn = userDefaults.bool(forKey: "mySwitchValue")
        
    }
    
    @IBAction func notificationOnOff(_ sender: UISwitch) {
        
        userDefaults.set(sender.isOn, forKey: "mySwitchValue")
        
    }
}
