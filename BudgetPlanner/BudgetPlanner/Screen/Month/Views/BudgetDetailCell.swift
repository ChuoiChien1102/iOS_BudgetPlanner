//
//  BudgetDetailCell.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 1/30/21.
//

import UIKit

class BudgetDetailCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbDate: UILabel!
    @IBOutlet weak var lbPayment: UILabel!
    @IBOutlet weak var lbRemain: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(payment: Payment, month: String) {
        icon.image = UIImage(named: payment.imageName)
        lbName.text = payment.name
        lbDate.text = payment.startDay + "/" + month
        lbPayment.text = payment.total + " $"
        if Double(payment.total)! >= 0 {
            lbPayment.textColor = UIColor.init(hex: "#4FBE40")
        } else {
            lbPayment.textColor = .red
        }
        lbRemain.text = payment.ending
    }
}
