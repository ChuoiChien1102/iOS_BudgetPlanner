//
//  AssetDetailViewController.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit

class AssetDetailViewController: BaseViewController {
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var lbTotal: UILabel!
    var planParent = Plan()
    var asset = Asset()
    var expensesMonth = MonthExpenses()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationBar.titleLabel.text = asset.name
        navigationBar.leftButton.isHidden = false
        navigationBar.backLabel.isHidden = false
        navigationBar.rightButton.isHidden = true
        
        navigationBar.leftButton.addTarget(self, action: #selector(clickBack(sender:)), for: UIControl.Event.touchUpInside)
        
        // tableView
        tableView.registerCellNib(ListPaymentCell.self)
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let payments = DatabaseRealmManager.shared.listAllPaymentOfAsset(assetID: asset.id)
        asset.payments = payments
        let sum = getTotalOfAsset(asset: asset)
        if sum >= 0 {
            lbTotal.textColor = UIColor.init(hex: "#4FBE40")
        } else {
            lbTotal.textColor = .red
        }
        lbTotal.text = String(sum) + " $"
        
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @objc func clickBack(sender: UIButton!) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func clickAddPayment(_ sender: Any) {
        let vc = PaymentViewController.newInstance()
        vc.assetParent = asset
        vc.expensesMonth = expensesMonth
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AssetDetailViewController {
    func getTotalOfAsset(asset: Asset) -> Double {
        var sum = 0.0
        for item in asset.payments {
            sum = sum + Double(item.total)!
        }
        return sum
    }
}

extension AssetDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return asset.payments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String.className(ListPaymentCell.self)) as! ListPaymentCell
        let item = asset.payments[indexPath.row]
        cell.configCell(payment: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       return 46
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 46
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = asset.payments[indexPath.row]
        let vc = PaymentViewController.newInstance()
        vc.isEdit = true
        vc.paymentExist = item
        vc.assetParent = asset
        vc.expensesMonth = expensesMonth
        navigationController?.pushViewController(vc, animated: true)
    }
}

