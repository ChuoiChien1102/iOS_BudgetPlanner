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
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAssetSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.deleteAssetSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deletePaymentSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.deletePaymentSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAssetSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.updateAssetSuccess), object: nil)
        navigationBar.titleLabel.text = "Group: " + asset.name
        navigationBar.leftButton.isHidden = false
        navigationBar.backLabel.isHidden = false
        navigationBar.rightButton.isHidden = false
        navigationBar.rightButton.setTitle("Remove", for: .normal)
        navigationBar.leftButton.addTarget(self, action: #selector(clickBack(sender:)), for: UIControl.Event.touchUpInside)
        navigationBar.rightButton.addTarget(self, action: #selector(removeAsset(sender:)), for: UIControl.Event.touchUpInside)
        let tapCategoryRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(changeAssetName(_:)))
        tapCategoryRecognizer.cancelsTouchesInView = false
        self.navigationBar.titleLabel.addGestureRecognizer(tapCategoryRecognizer)
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
        updateUIButtonRemove()
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
    
    @objc func removeAsset(sender: UIButton!) {
        updateUIButtonRemove()
        if(self.tableView.isEditing == true)
        {
            self.tableView.isEditing = false
            navigationBar.rightButton.setTitle("Remove", for: .normal)
        }
        else
        {
            self.tableView.isEditing = true
            navigationBar.rightButton.setTitle("Done", for: .normal)
        }
    }
    func updateUIButtonRemove() {
        if asset.payments.count == 0 {
            navigationBar.rightButton.isEnabled = false
            navigationBar.rightButton.setTitleColor(.gray, for: .normal)
        } else {
            navigationBar.rightButton.isEnabled = true
            navigationBar.rightButton.setTitleColor(.white, for: .normal)
        }
    }
    
    @objc func changeAssetName(_ sender: UITapGestureRecognizer) -> Void {
        let ac = UIAlertController(title: "Group Name", message: "Change group name", preferredStyle: .alert)
        ac.addTextField()
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            // do something
        }
        let actionOK = UIAlertAction(title: "Change", style: .default) { [unowned ac] _ in
            let textField = ac.textFields![0]
            let name = textField.text!.trimSpace()
            if (name == "") {
                self.showAlert(title: "Alert", content: "Please name your group!")
                return
            }
            self.navigationBar.titleLabel.text = "Group: " + name
            self.asset.name = name
            LoadingManager.show(in: self)
            DatabaseRealmManager.shared.editAssetName(newAsset: self.asset)
        }
        
        ac.addAction(actionCancel)
        ac.addAction(actionOK)
        present(ac, animated: true)
    }
    
    func showAlert(title: String, content: String) {
        let ac = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default) { _ in
            
        }
        ac.addAction(actionOK)
        present(ac, animated: true)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let payment = self.asset.payments[indexPath.row]
            
            let ac = UIAlertController(title: "Alert", message: "Are you sure want to delete this transaction(" + payment.name + ")?", preferredStyle: .alert)
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
                // do something
            }
            let actionOK = UIAlertAction(title: "Yes", style: .default) { _ in
                LoadingManager.show(in: self)
                DatabaseRealmManager.shared.removePayment(id: payment.id)
                self.asset.payments.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            ac.addAction(actionOK)
            ac.addAction(actionCancel)
            present(ac, animated: true)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension AssetDetailViewController {
    @objc func deleteAssetSuccess(_ notification: Notification) {
        LoadingManager.hide()
    }
    @objc func deletePaymentSuccess(_ notification: Notification) {
        LoadingManager.hide()
        updateUIButtonRemove()
    }
    @objc func updateAssetSuccess(_ notification: Notification) {
        LoadingManager.hide()
    }
}
