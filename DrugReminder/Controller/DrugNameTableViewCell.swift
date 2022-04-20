//
//  DrugNameTableViewCell.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/12.
//

import UIKit

class DrugNameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dosesPerDayLabel: UILabel!
    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var time3Label: UILabel!
    @IBOutlet weak var time4Label: UILabel!
    
    
    static let identifier = "DrugNameTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "DrugNameTableViewCell", bundle: nil)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        checkmarkButton.setImage(UIImage(named: "rectangle"), for: .normal)
        //        checkmarkButton.setBackgroundImage(UIImage(named: "rectangle"), for: .normal)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func checkButton(_ sender: UIButton) {
        sender.setBackgroundImage(UIImage(named: "checkmark.square"), for: .normal)
    }
}
