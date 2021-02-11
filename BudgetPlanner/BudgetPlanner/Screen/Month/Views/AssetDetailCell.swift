//
//  AssetDetailCell.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 1/30/21.
//

import UIKit

class AssetDetailCell: UITableViewCell {
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbStartDate: UILabel!
    @IBOutlet weak var lbPayment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(asset: Asset, month: String) {
        icon.image = UIImage(named: asset.payments.first!.imageName)
        lbName.text = asset.name
        let total = getTotalOfAsset(listPayment: asset.payments)
        lbPayment.text = String(total) + " $"
        if total >= 0 {
            lbPayment.textColor = UIColor.init(hex: "#4FBE40")
        } else {
            lbPayment.textColor = .red
        }
        lbStartDate.text = asset.payments.first!.startDay + "/" + month
    }
    
    func getTotalOfAsset(listPayment: [Payment]) -> Double {
        var sum = 0.0
        for item in listPayment {
            sum = sum + Double(item.total)!
        }
        return sum
    }
}
