//
//  MonthDetailCell.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 1/30/21.
//

import UIKit

class MonthDetailCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var leftIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configStartingCell(item: MonthExpenses) -> Void {
        name.text = "Starting"
        total.text = item.starting + " $"
        if Double(item.starting)! >= 0 {
            total.textColor = UIColor.init(hex: "#4FBE40")
        } else {
            total.textColor = .red
        }
        leftIcon.isHidden = true
    }
    func configEndingCell(item: MonthExpenses) -> Void {
        name.text = "Ending"
        total.text = item.ending + " $"
        if Double(item.ending)! >= 0 {
            total.textColor = UIColor.init(hex: "#4FBE40")
        } else {
            total.textColor = .red
        }
        leftIcon.isHidden = true
    }
}
