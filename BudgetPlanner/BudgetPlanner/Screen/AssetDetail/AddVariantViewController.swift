//
//  AddVariantViewController.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit

class AddVariantViewController: BaseViewController {
    @IBOutlet weak var navigationBar: NavigationBar!
    var planParent = Plan()
    var asset = Asset()
    var expensesMonth = MonthExpenses()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let number = UserDefaults.standard.integer(forKey: KEY_NUMBER_VARIANT)
        // case create variant
        navigationBar.titleLabel.text = "New variant"
        asset.name = navigationBar.titleLabel.text!
        navigationBar.leftButton.isHidden = false
        navigationBar.backLabel.isHidden = false
        navigationBar.rightButton.isHidden = true
        navigationBar.leftButton.addTarget(self, action: #selector(clickBack(sender:)), for: UIControl.Event.touchUpInside)
        let tapCategoryRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(changeAssetName(_:)))
        tapCategoryRecognizer.cancelsTouchesInView = false
        self.navigationBar.titleLabel.addGestureRecognizer(tapCategoryRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    @objc func changeAssetName(_ sender: UITapGestureRecognizer) -> Void {
        let ac = UIAlertController(title: "Group Name", message: "Change group name", preferredStyle: .alert)
        ac.addTextField()
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
            // do something
        }
        let actionOK = UIAlertAction(title: "Change", style: .default) { _ in
            let textField = ac.textFields![0]
            let name = textField.text!.trimSpace()
            if (name == "") {
                self.showAlert(title: "Alert", content: "Please name your group!")
                return
            }
            self.navigationBar.titleLabel.text = "Group: " + name
            self.asset.name = name
        }
        
        ac.addAction(actionCancel)
        ac.addAction(actionOK)
        present(ac, animated: true)
    }
    @IBAction func clickAddPayment(_ sender: Any) {
        let vc = PaymentViewController.newInstance()
        vc.planParent = planParent
        vc.assetParent = asset
        vc.expensesMonth = expensesMonth
        vc.isFromCreateVariant = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func showAlert(title: String, content: String) {
        let ac = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default) { _ in
            
        }
        ac.addAction(actionOK)
        present(ac, animated: true)
    }
}
