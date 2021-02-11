//
//  ListPaymentCell.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 1/30/21.
//

import UIKit

class ListPaymentCell: UITableViewCell {
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPayment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(payment: Payment) {
        lbName.text = payment.name
        lbPayment.text = payment.total + " $"
        if Double(payment.total)! >= 0 {
            lbPayment.textColor = UIColor.init(hex: "#4FBE40")
        } else {
            lbPayment.textColor = .red
        }
    }
}
