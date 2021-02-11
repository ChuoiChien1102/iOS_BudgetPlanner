//
//  MonthViewController.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit

class MonthViewController: BaseViewController {
    @IBOutlet weak var navigationBar: NavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    var planParent = Plan()
    var expensesMonth = MonthExpenses()
    var listPayment = [Payment]()
    var listAsset = [Asset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(createPlanSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.createPlanSuccess), object: nil)
        
        navigationBar.titleLabel.text = expensesMonth.month
        navigationBar.leftButton.isHidden = false
        navigationBar.backLabel.isHidden = false
        navigationBar.rightButton.isHidden = true
        
        navigationBar.leftButton.addTarget(self, action: #selector(clickBack(sender:)), for: UIControl.Event.touchUpInside)
        
        // tableView
        tableView.registerCellNib(TitleCell.self)
        tableView.registerCellNib(BudgetDetailCell.self)
        tableView.registerCellNib(BudgetTotalCell.self)
        tableView.registerCellNib(AssetDetailCell.self)
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let listAllAssetOfPlan = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: planParent.id)
        
        // get all asset in month
        var listAllAssetOfMonth = [Asset]()
        for asset in listAllAssetOfPlan {
            for pay in asset.payments {
                if (checkPaymentIsInMonth(pay: pay)) {
                    listAllAssetOfMonth.append(asset)
                    break
                }
            }
        }
        listAsset = listAllAssetOfMonth
        // get all payment in month
        var listAllPayment = [Payment]()
        for asset in listAsset {
            let payments = DatabaseRealmManager.shared.listAllPaymentOfAsset(assetID: asset.id)
            var listPaymentOfAssetInMonth = [Payment]()
            for pay in payments {
                if (checkPaymentIsInMonth(pay: pay)) {
                    listAllPayment.append(pay)
                    listPaymentOfAssetInMonth.append(pay)
                }
            }
            asset.payments = listPaymentOfAssetInMonth.sorted(by: { (pay1, pay2) -> Bool in
                return pay1.startDay <= pay2.startDay
            })
        }
        listAsset = listAsset.sorted(by: { (asset1, asset2) -> Bool in
            return asset1.payments.first!.startDay <= asset2.payments.first!.startDay
        })
        listPayment = listAllPayment.sorted(by: { (pay1, pay2) -> Bool in
            return pay1.startDay <= pay2.startDay
        })
        // caculator payment
        for i in 0..<listPayment.count {
            let pay = listPayment[i]
            if i == 0 {
                pay.starting = expensesMonth.starting
            } else {
                let periousPay = listPayment[i - 1]
                pay.starting = periousPay.ending
            }
            pay.ending = String(Double(pay.total)! + Double(pay.starting)!)
        }
        
        // caculator income, expenses
        var income = 0.0
        var expenses = 0.0
        for pay in listPayment {
            if Double(pay.total)! > 0 {
                income = income + Double(pay.total)!
            } else {
                expenses = expenses + Double(pay.total)!
            }
        }
        expensesMonth.income = String(income)
        expensesMonth.expenses = String(expenses)
        
        let ending = Double(expensesMonth.starting)! + income + expenses
        expensesMonth.ending = String(ending)
        
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
    
    @IBAction func addAsset(_ sender: Any) {
        let ac = UIAlertController(title: "Asset Name", message: "A message should be a short, complete sentence", preferredStyle: .alert)
        ac.addTextField()
        
        let actionCancle = UIAlertAction(title: "Cancle", style: .default) { _ in
            // do something
        }
        let actionOK = UIAlertAction(title: "Create", style: .default) { [unowned ac] _ in
            let textField = ac.textFields![0]
            let name = textField.text!.trimSpace()
            if (name == "") {
                Common.showAlert(content: "Please fill name!")
                return
            }
            let vc = PaymentViewController.newInstance()
            let asset = Asset()
            asset.name = name
            asset.parentID = self.planParent.id
            vc.assetParent = asset
            vc.expensesMonth = self.expensesMonth
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        ac.addAction(actionCancle)
        ac.addAction(actionOK)
        present(ac, animated: true)
    }
}

extension MonthViewController {
    
    @objc func addMonthVariant(sender: UIButton!) {
        var listAssetCopy = [Asset]()
        for asset in listAsset {
            let newAsset = Asset()
            newAsset.name = asset.name
            newAsset.parentID = asset.parentID
            newAsset.payments = asset.payments
            listAssetCopy.append(newAsset)
        }
        LoadingManager.show(in: self)
        for asset in listAssetCopy {
            for pay in asset.payments {
                let newPay = Payment()
                newPay.name = pay.name
                newPay.imageName = pay.imageName
                newPay.type = pay.type
                newPay.typeName = pay.typeName
                newPay.startDay = pay.startDay
                newPay.startMonth = expensesMonth.indexMonth
                newPay.startYear = pay.startYear
                newPay.isRecuring = false
                newPay.starting = pay.starting
                newPay.ending = pay.ending
                newPay.total = pay.total
                
                let plan = Plan()
                plan.name = planParent.name + " copy"
                let newAsset = Asset()
                newAsset.name = asset.name
                newAsset.payments = [newPay]
                plan.assets = [newAsset]
                DatabaseRealmManager.shared.createPlan(plan: plan)
            }
        }
        LoadingManager.hide()
        navigationController?.popViewController(animated: true)
    }
    
//    @objc func createPlanSuccess(_ notification: Notification) {
//        navigationController?.popViewController(animated: true)
//    }
    
    func checkPaymentIsInMonth(pay: Payment) -> Bool {
        if !pay.isRecuring {
            if pay.startMonth == expensesMonth.indexMonth  && pay.startYear == expensesMonth.year {
                return true
            } else {
                return false
            }
        } else {
            let startDate = pay.startDay + "/" + pay.startMonth + "/" + pay.startYear
            let thisMonth = pay.startDay + "/" + expensesMonth.indexMonth + "/" + expensesMonth.year
            let endDate = pay.endDay + "/" + pay.endMonth + "/" + pay.endYear
            if Date().convertStringToDate(startDate, "dd/MM/yyyy") <= Date().convertStringToDate(thisMonth, "dd/MM/yyyy") && Date().convertStringToDate(thisMonth, "dd/MM/yyyy") <= Date().convertStringToDate(endDate, "dd/MM/yyyy") {
                return true
            } else {
                return false
            }
        }
    }
}

extension MonthViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return listPayment.count + 2
        } else {
            return listAsset.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // Cell title
                let cell = tableView.dequeueReusableCell(withIdentifier: String.className(TitleCell.self)) as! TitleCell
                cell.configCell(name: "Budget")
                return cell
            } else if indexPath.row == listPayment.count + 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String.className(BudgetTotalCell.self)) as! BudgetTotalCell
                cell.configCell(expenses: expensesMonth)
                cell.btnAddMonthVariant.addTarget(self, action: #selector(addMonthVariant(sender:)), for: UIControl.Event.touchUpInside)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String.className(BudgetDetailCell.self)) as! BudgetDetailCell
                let payment = listPayment[indexPath.row - 1]
                cell.configCell(payment: payment, month: expensesMonth.indexMonth)
                return cell
            }
        } else {
            if indexPath.row == 0 {
                // Cell title
                let cell = tableView.dequeueReusableCell(withIdentifier: String.className(TitleCell.self)) as! TitleCell
                cell.configCell(name: "Asset")
                return cell
            }  else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String.className(AssetDetailCell.self)) as! AssetDetailCell
                let asset = listAsset[indexPath.row - 1]
                cell.configCell(asset: asset, month: expensesMonth.indexMonth)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 30
            } else if indexPath.row == listPayment.count + 1 {
                return 210
            } else {
                return 46
            }
        } else {
            if indexPath.row == 0 {
                return 30
            } else {
                return 46
            }
        }
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 46
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            if indexPath.row > 0 {
                let asset = listAsset[indexPath.row - 1]
                let vc = AssetDetailViewController.newInstance()
                vc.asset = asset
                vc.expensesMonth = expensesMonth
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

