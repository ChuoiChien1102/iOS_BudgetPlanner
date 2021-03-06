//
//  DifferenceCell.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 1/30/21.
//

import UIKit

class DifferenceCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var iconRight: UIImageView!
    
    @IBOutlet weak var viewSeperator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configDifferenceCell(item: MonthExpenses) -> Void {
        name.text = "Difference"
        let totalDifference = Double(item.income)! + Double(item.expenses)!
        total.text = String(totalDifference) + " $"
        if totalDifference > 0 {
            total.textColor = UIColor.init(hex: "#4FBE40")
            iconRight.image = UIImage(named: "ic_arrow_green")
            iconRight.isHidden = false
        } else if totalDifference < 0 {
            total.textColor = .red
            iconRight.image = UIImage(named: "ic_arrow_red")
            iconRight.isHidden = false
        } else {
            total.textColor = .gray
            iconRight.isHidden = true
        }
    }
}
