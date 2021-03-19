//
//  PaymentViewController.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit
import ActionSheetPicker_3_0

class PaymentViewController: BaseViewController {
    @IBOutlet weak var navigationBar: NavigationBar!
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lbType: UILabel!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var lbStartDate: UILabel!
    @IBOutlet weak var textFieldEndDate: MonthYearTextField!
    @IBOutlet weak var viewEndDate: UIView!
    @IBOutlet weak var swipe: UISwitch!
    
    var expensesMonth = MonthExpenses()
    var planParent = Plan()
    var assetParent = Asset()
    var paymentExist = Payment()
    var paymentOld = Payment()
    var isEdit = false
    var isFromCreateVariant = false
    var startDateSelected = Date()
    var minStartDate = Date()
    var categorySelected = CategoryModel()
    
    var isRecuring = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(createPlanSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.createPlanSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createAssetSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.createAssetSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createPaymentSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.createPaymentSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePaymentSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.updatePaymentSuccess), object: nil)
        
        let tapCategoryRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(selectType(_:)))
        tapCategoryRecognizer.cancelsTouchesInView = false
        self.lbType.addGestureRecognizer(tapCategoryRecognizer)
        
        let tapStartRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(selectStartDate(_:)))
        tapStartRecognizer.cancelsTouchesInView = false
        self.lbStartDate.addGestureRecognizer(tapStartRecognizer)
        
        navigationBar.titleLabel.text = "Group: " + assetParent.name
        navigationBar.leftButton.isHidden = false
        navigationBar.backLabel.isHidden = false
        navigationBar.rightButton.isHidden = true
        navigationBar.widthRightButtonContraint.constant = 0
        navigationBar.leftButton.addTarget(self, action: #selector(clickBack(sender:)), for: UIControl.Event.touchUpInside)
        
        txtAmount.delegate = self
        if isEdit == true {
            // set oldPayment status
            paymentOld.name = paymentExist.name
            paymentOld.typeName = paymentExist.typeName
            paymentOld.total = paymentExist.total
            paymentOld.startDay = paymentExist.startDay
            paymentOld.startMonth = paymentExist.startMonth
            paymentOld.startYear = paymentExist.startYear
            paymentOld.endDay = paymentExist.endDay
            paymentOld.endMonth = paymentExist.endMonth
            paymentOld.endYear = paymentExist.endYear
            paymentOld.isRecuring = paymentExist.isRecuring
            
            isRecuring = paymentExist.isRecuring
            txtName.text = paymentExist.name
            lbType.text = paymentExist.typeName
            txtAmount.text = paymentExist.total
        } else {
            // payment name label.text should be equal = asset name. (On other flow, no default)
            txtName.text = assetParent.name
            
            // set oldPayment status
            paymentOld.name = assetParent.name
            categorySelected = Common.listPaymentType()[4]
            paymentOld.typeName = categorySelected.name
            paymentOld.type = categorySelected.type
            paymentOld.imageName = categorySelected.imageName
            lbType.text = categorySelected.name
            paymentOld.startDay = "01"
            paymentOld.startMonth = expensesMonth.indexMonth
            paymentOld.startYear = expensesMonth.year
        }
        updateUIIsRecuring()
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
        if checkIsChangeValue() && txtName.text != "" && txtAmount.text != "" {
            let ac = UIAlertController(title: "Alert", message: "Do you want to save before leaving?", preferredStyle: .alert)
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
                // do something
                self.navigationController?.popViewController(animated: true)
            }
            let actionOK = UIAlertAction(title: "Save", style: .default) { _ in
                self.save()
            }
            ac.addAction(actionOK)
            ac.addAction(actionCancel)
            present(ac, animated: true)
        } else if checkIsChangeValue() && (txtName.text == "" || txtAmount.text == "") {
            let ac = UIAlertController(title: "Alert", message: "Do you want to leave without saving?", preferredStyle: .alert)
            
            let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { _ in
                // back without saving
                self.navigationController?.popViewController(animated: true)
            }
            let actionOK = UIAlertAction(title: "Stay", style: .default) { _ in
                return
            }
            ac.addAction(actionOK)
            ac.addAction(actionCancel)
            present(ac, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    func updateUIIsRecuring() {
        swipe.isOn = isRecuring
        
        let minStartDateString = "01/" + expensesMonth.indexMonth + "/" + expensesMonth.year
        minStartDate = Date().convertStringToDate(minStartDateString, "dd/MM/yyyy")
        
        if isEdit == true {
            if isRecuring == true {
                viewEndDate.isHidden = false
                if lbStartDate.text == "" {
                    lbStartDate.text = paymentExist.startDay + "/" + paymentExist.startMonth + "/" + paymentExist.startYear
                    startDateSelected = Date().convertStringToDate(lbStartDate.text!, "dd/MM/yyyy")
                }
                let nextMonth = startDateSelected.getNextMonth()
                if textFieldEndDate.text == "" && paymentExist.endDay != "" && paymentExist.endMonth != "" && paymentExist.endYear != "" {
                    textFieldEndDate.text = paymentExist.endDay + "/" + paymentExist.endMonth + "/" + paymentExist.endYear
                    textFieldEndDate.minDate = nextMonth
                } else {
                    textFieldEndDate.text = KEY_INFINITY
                    textFieldEndDate.minDate = nextMonth
                }
                textFieldEndDate.dateSelected = nextMonth
            } else {
                viewEndDate.isHidden = true
                if lbStartDate.text == "" {
                    lbStartDate.text = paymentExist.startDay + "/" + paymentExist.startMonth + "/" + paymentExist.startYear
                    startDateSelected = Date().convertStringToDate(lbStartDate.text!, "dd/MM/yyyy")
                }
                textFieldEndDate.text = ""
            }
        } else {
            if isRecuring == true {
                viewEndDate.isHidden = false
                if lbStartDate.text == "" {
                    lbStartDate.text = minStartDateString
                    startDateSelected = Date().convertStringToDate(lbStartDate.text!, "dd/MM/yyyy")
                }
                let nextMonth = startDateSelected.getNextMonth()
                textFieldEndDate.text = KEY_INFINITY
                textFieldEndDate.minDate = nextMonth
                textFieldEndDate.dateSelected = nextMonth
            } else {
                viewEndDate.isHidden = true
                if lbStartDate.text == "" {
                    lbStartDate.text = minStartDateString
                    startDateSelected = Date().convertStringToDate(lbStartDate.text!, "dd/MM/yyyy")
                }
                textFieldEndDate.text = ""
            }
        }
        
        // if end date is infinity
        if textFieldEndDate.text == VALUE_INFINITY {
            textFieldEndDate.text = KEY_INFINITY
        }
    }
    @IBAction func swipeRecuring(_ sender: Any) {
        isRecuring = !isRecuring
        updateUIIsRecuring()
    }
    func save() {
        if txtName.text == "" {
            showAlert(title: "Alert", content: "Fill a payment name")
            return
        }
        if txtAmount.text == "" {
            showAlert(title: "Alert", content: "Fill a payment price")
            return
        }
        var stringEndDate = textFieldEndDate.text
        if textFieldEndDate.text == KEY_INFINITY {
            stringEndDate = VALUE_INFINITY
        }
        if isEdit == true {
            let arrStart = lbStartDate.text?.split(separator: "/")
            let arrEnd = stringEndDate!.split(separator: "/")
            paymentExist.name = txtName.text!
            paymentExist.startDay = String(arrStart![0])
            paymentExist.startMonth = String(arrStart![1])
            paymentExist.startYear = String(arrStart![2])
            if isRecuring {
                paymentExist.endDay = String(arrEnd[0])
                paymentExist.endMonth = String(arrEnd[1])
                paymentExist.endYear = String(arrEnd[2])
            }
            paymentExist.isRecuring = isRecuring
            paymentExist.total = String(Double(txtAmount.text!)!)
            paymentExist.assetParentID = assetParent.id
            
            LoadingManager.show(in: self)
            DatabaseRealmManager.shared.editPayment(newPayment: paymentExist)
        } else if assetParent.id == "" && assetParent.parentID != "" {
            // create both asset and payment
            let arrStart = lbStartDate.text?.split(separator: "/")
            let arrEnd = stringEndDate!.split(separator: "/")
            let payment = Payment()
            payment.name = txtName.text!
            payment.imageName = categorySelected.imageName
            payment.type = categorySelected.type
            payment.typeName = lbType.text!
            payment.startDay = String(arrStart![0])
            payment.startMonth = String(arrStart![1])
            payment.startYear = String(arrStart![2])
            if isRecuring {
                payment.endDay = String(arrEnd[0])
                payment.endMonth = String(arrEnd[1])
                payment.endYear = String(arrEnd[2])
            }
            payment.isRecuring = isRecuring
            payment.total = String(Double(txtAmount.text!)!)
            payment.assetParentID = assetParent.id
            
            assetParent.payments = [payment]
            LoadingManager.show(in: self)
            DatabaseRealmManager.shared.createAsset(asset: assetParent)
        } else if assetParent.id != "" && assetParent.parentID != ""{
            // create only payment
            let arrStart = lbStartDate.text?.split(separator: "/")
            let arrEnd = stringEndDate!.split(separator: "/")
            let payment = Payment()
            payment.name = txtName.text!
            payment.imageName = categorySelected.imageName
            payment.type = categorySelected.type
            payment.typeName = lbType.text!
            payment.startDay = String(arrStart![0])
            payment.startMonth = String(arrStart![1])
            payment.startYear = String(arrStart![2])
            if isRecuring {
                payment.endDay = String(arrEnd[0])
                payment.endMonth = String(arrEnd[1])
                payment.endYear = String(arrEnd[2])
            }
            payment.isRecuring = isRecuring
            payment.total = String(Double(txtAmount.text!)!)
            payment.assetParentID = assetParent.id
            
            LoadingManager.show(in: self)
            DatabaseRealmManager.shared.createPayment(payment: payment)
        } else if isFromCreateVariant == true {
            
            // create new plan, asset, payment
            // create asset and payment
            let arrStart = lbStartDate.text?.split(separator: "/")
            let arrEnd = stringEndDate!.split(separator: "/")
            let payment = Payment()
            payment.name = txtName.text!
            payment.imageName = categorySelected.imageName
            payment.type = categorySelected.type
            payment.typeName = lbType.text!
            payment.startDay = String(arrStart![0])
            payment.startMonth = String(arrStart![1])
            payment.startYear = String(arrStart![2])
            if isRecuring {
                payment.endDay = String(arrEnd[0])
                payment.endMonth = String(arrEnd[1])
                payment.endYear = String(arrEnd[2])
            }
            payment.isRecuring = isRecuring
            payment.total = String(Double(txtAmount.text!)!)
            payment.assetParentID = assetParent.id
            
            let newAsset = Asset()
            newAsset.name = assetParent.name
            newAsset.payments = [payment]
            // create new plan
            let plan = Plan()
            plan.name = planParent.name + " copy"
            // copy all old asset, payment of old plan => new plan
            var listAssetOfOldPlan = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: planParent.id)
            listAssetOfOldPlan.append(newAsset)
            plan.assets = listAssetOfOldPlan
            LoadingManager.show(in: self)
            DatabaseRealmManager.shared.createPlan(plan: plan)
        }
    }
    @IBAction func clickSave(_ sender: Any) {
        save()
    }
}

extension PaymentViewController {
    func checkIsChangeValue() -> Bool {
        if paymentOld.name != txtName.text {
            return true
        }
        if paymentOld.typeName != lbType.text {
            return true
        }
        if paymentOld.total != txtAmount.text {
            return true
        }
        if paymentOld.isRecuring != isRecuring {
            return true
        }
        if paymentOld.startDay + "/" + paymentOld.startMonth + "/" + paymentOld.startYear != lbStartDate.text {
            return true
        }
        if paymentOld.endDay + "/" + paymentOld.endMonth + "/" + paymentOld.endYear != textFieldEndDate.text && paymentOld.isRecuring == true {
            return true
        }
        return false
    }
    @objc func createPlanSuccess(_ notification: Notification) {
        navigationController?.popToRootViewController(animated: true)
    }
    @objc func createAssetSuccess(_ notification: Notification) {
        LoadingManager.hide()
        navigationController?.popViewController(animated: true)
    }
    @objc func createPaymentSuccess(_ notification: Notification) {
        LoadingManager.hide()
        navigationController?.popViewController(animated: true)
    }
    @objc func updatePaymentSuccess(_ notification: Notification) {
        LoadingManager.hide()
        navigationController?.popViewController(animated: true)
    }
    @objc func selectStartDate(_ sender: UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .date, selectedDate: startDateSelected , minimumDate: nil, maximumDate: nil, doneBlock: { (picker, value, index) in
            let date = value as! Date
            let day = date.getDay()
            var dateString = date.convertDateToString(date, "dd/MM/yyyy")
            if (self.isRecuring) && Int(day)! > 28 {
                dateString.removeFirst()
                dateString.removeFirst()
                dateString = "28" + dateString
            }
            self.lbStartDate.text = dateString
            self.startDateSelected = date
            
            let nextMonth = self.startDateSelected.getNextMonth()
            self.textFieldEndDate.text = nextMonth
            self.textFieldEndDate.minDate = nextMonth
            self.textFieldEndDate.dateSelected = nextMonth
        }, cancel: { ActionStringCancelBlock in return }, origin: view.superview!.superview)
    }
    @objc func selectType(_ sender: UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
        let vc = SelectedViewController.newInstance()
        vc.data = Common.listPaymentType()
        vc.onSelectedDetails = { item in
            self.lbType.text = item.name
            self.categorySelected = item
            
            if self.isEdit == true {
                self.paymentExist.imageName = self.categorySelected.imageName
                self.paymentExist.type = self.categorySelected.type
                self.paymentExist.typeName = self.categorySelected.name
            }
        }
        appDelegate?.rootViewController.presentModalyWithoutAnimate(vc)
    }
    
    func showAlert(title: String, content: String) {
        let ac = UIAlertController(title: title, message: content, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "Ok", style: .default) { _ in
            
        }
        ac.addAction(actionOK)
        present(ac, animated: true)
    }
}

extension PaymentViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text?.trimSpace() != "") {
            var countDot = 0
            var isMinus = false
            let firstChar = textField.text?.first
            if firstChar == "-" {
                isMinus = true
            }
            for char in textField.text! {
                if (char >= "0" && char <= "9") {
                    //not do something
                } else if (char == "," || char == ".") {
                    countDot = countDot + 1
                } else {
                    textField.text?.remove(at: textField.text!.firstIndex(of: char)!)
                }
            }
            if countDot <= 1 && textField.text!.count >= 2 {
                textField.text = textField.text!.replacingOccurrences(of: ",", with: ".")
            } else {
                textField.text = textField.text!.replacingOccurrences(of: ",", with: "")
                textField.text = textField.text!.replacingOccurrences(of: ".", with: "")
            }
            
            if isMinus && textField.text!.count > 1 {
                textField.text = "-\(textField.text!)"
            }
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
