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
    
    func configIncomeCell(item: MonthExpenses) -> Void {
        name.text = "Income"
        total.text = item.income + " $"
        total.textColor = UIColor.init(hex: "#4FBE40")
        leftIcon.image = UIImage(named: "ic_up_green")
        leftIcon.isHidden = false
    }
    func configExpensesCell(item: MonthExpenses) -> Void {
        name.text = "Expenses"
        total.text = item.expenses + " $"
        total.textColor = .red
        leftIcon.image = UIImage(named: "ic_down_red")
        leftIcon.isHidden = false
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
