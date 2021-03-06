//
//  BudgetTotalCell.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 1/30/21.
//

import UIKit

class BudgetTotalCell: UITableViewCell {
    
    @IBOutlet weak var lbInCome: UILabel!
    @IBOutlet weak var lbExpenses: UILabel!
    @IBOutlet weak var lbStart: UILabel!
    @IBOutlet weak var lbEnd: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(expenses: MonthExpenses) {
        lbInCome.text = expenses.income + " $"
        lbExpenses.text = expenses.expenses + " $"
        lbStart.text = expenses.starting + " $"
        lbEnd.text = expenses.ending + " $"
        if Double(expenses.starting)! >= 0 {
            lbStart.textColor = UIColor.init(hex: "#4FBE40")
        } else {
            lbStart.textColor = .red
        }
        if Double(expenses.ending)! >= 0 {
            lbEnd.textColor = UIColor.init(hex: "#4FBE40")
        } else {
            lbEnd.textColor = .red
        }
    }
}
