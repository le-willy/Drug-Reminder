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
    @IBOutlet weak var checkmarkButton: UIButton!
    
    var drugModel = DrugModel()
    
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
