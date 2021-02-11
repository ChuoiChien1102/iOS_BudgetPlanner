//
//  MonthTitleCell.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 1/30/21.
//

import UIKit

class MonthTitleCell: UITableViewCell {

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
    
    func configCell(item: MonthExpenses) -> Void {
        name.text = item.month + " (" + item.year + ")"
        if Double(item.ending)! >= 0 {
            total.textColor = UIColor.init(hex: "#4FBE40")
        } else {
            total.textColor = .red
        }
        total.text = item.ending + " $"
        if item.isExpand {
            iconRight.image = UIImage(named: "ic_arrow_down")
        } else {
            iconRight.image = UIImage(named: "ic_arrow_right")
        }
        viewSeperator.isHidden = item.isExpand
    }
}
