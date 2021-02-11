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
    @IBOutlet weak var lbEndDate: UILabel!
    @IBOutlet weak var viewEndDate: UIView!
    @IBOutlet weak var swipe: UISwitch!
    
    var expensesMonth = MonthExpenses()
    var assetParent = Asset()
    var paymentExist = Payment()
    var isEdit = false
    var startDateSelected = Date()
    var endDateSelected = Date()
    var minStartDate = Date()
    var minEndDate = Date()
    var categorySelected = CategoryModel()
    
    var isRecuring = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(createAssetSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.createAssetSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(createPaymentSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.createPaymentSuccess), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updatePaymentSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.updatePaymentSuccess), object: nil)
        
        let tapCategoryRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(selectType(_:)))
        tapCategoryRecognizer.cancelsTouchesInView = false
        self.lbType.addGestureRecognizer(tapCategoryRecognizer)
        
        let tapStartRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(selectStartDate(_:)))
        tapStartRecognizer.cancelsTouchesInView = false
        self.lbStartDate.addGestureRecognizer(tapStartRecognizer)
        
        let tapEndRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(selectEndDate(_:)))
        tapEndRecognizer.cancelsTouchesInView = false
        self.lbEndDate.addGestureRecognizer(tapEndRecognizer)
        
        navigationBar.titleLabel.text = assetParent.name
        navigationBar.leftButton.isHidden = false
        navigationBar.backLabel.isHidden = false
        navigationBar.rightButton.isHidden = true
        
        navigationBar.leftButton.addTarget(self, action: #selector(clickBack(sender:)), for: UIControl.Event.touchUpInside)
        
        txtAmount.delegate = self
        if isEdit == true {
            isRecuring = paymentExist.isRecuring
            txtName.text = paymentExist.name
            lbType.text = paymentExist.typeName
            txtAmount.text = paymentExist.total
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
        navigationController?.popViewController(animated: true)
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
                if lbEndDate.text == "" && paymentExist.endDay != "" && paymentExist.endMonth != "" && paymentExist.endYear != "" {
                    lbEndDate.text = paymentExist.endDay + "/" + paymentExist.endMonth + "/" + paymentExist.endYear
                    minEndDate = Date().convertStringToDate(nextMonth, "dd/MM/yyyy")
                } else {
                    lbEndDate.text = nextMonth
                    minEndDate = Date().convertStringToDate(lbEndDate.text!, "dd/MM/yyyy")
                }
                endDateSelected = Date().convertStringToDate(lbEndDate.text!, "dd/MM/yyyy")
            } else {
                viewEndDate.isHidden = true
                if lbStartDate.text == "" {
                    lbStartDate.text = paymentExist.startDay + "/" + paymentExist.startMonth + "/" + paymentExist.startYear
                    startDateSelected = Date().convertStringToDate(lbStartDate.text!, "dd/MM/yyyy")
                }
                lbEndDate.text = ""
            }
        } else {
            if isRecuring == true {
                viewEndDate.isHidden = false
                if lbStartDate.text == "" {
                    lbStartDate.text = minStartDateString
                    startDateSelected = Date().convertStringToDate(lbStartDate.text!, "dd/MM/yyyy")
                }
                let nextMonth = startDateSelected.getNextMonth()
                lbEndDate.text = nextMonth
                minEndDate = Date().convertStringToDate(lbEndDate.text!, "dd/MM/yyyy")
                endDateSelected = Date().convertStringToDate(lbEndDate.text!, "dd/MM/yyyy")
            } else {
                viewEndDate.isHidden = true
                if lbStartDate.text == "" {
                    lbStartDate.text = minStartDateString
                    startDateSelected = Date().convertStringToDate(lbStartDate.text!, "dd/MM/yyyy")
                }
                lbEndDate.text = ""
            }
        }
    }
    @IBAction func swipeRecuring(_ sender: Any) {
        isRecuring = !isRecuring
        updateUIIsRecuring()
    }
    
    @IBAction func clickSave(_ sender: Any) {
        if txtName.text == "" {
            Common.showAlert(content: "Please fill name")
            return
        }
        if txtAmount.text == "" {
            Common.showAlert(content: "Please fill amount")
            return
        }
        
        if isEdit == true {
            let arrStart = lbStartDate.text?.split(separator: "/")
            let arrEnd = lbEndDate.text?.split(separator: "/")
            paymentExist.name = txtName.text!
            paymentExist.startDay = String(arrStart![0])
            paymentExist.startMonth = String(arrStart![1])
            paymentExist.startYear = String(arrStart![2])
            if isRecuring {
                paymentExist.endDay = String(arrEnd![0])
                paymentExist.endMonth = String(arrEnd![1])
                paymentExist.endYear = String(arrEnd![2])
            }
            paymentExist.isRecuring = isRecuring
            paymentExist.total = String(Double(txtAmount.text!)!)
            paymentExist.assetParentID = assetParent.id
            
            LoadingManager.show(in: self)
            DatabaseRealmManager.shared.editPayment(newPayment: paymentExist)
        } else if assetParent.id == "" {
            // create both asset and payment
            let arrStart = lbStartDate.text?.split(separator: "/")
            let arrEnd = lbEndDate.text?.split(separator: "/")
            let payment = Payment()
            payment.name = txtName.text!
            payment.imageName = categorySelected.imageName
            payment.type = categorySelected.type
            payment.typeName = lbType.text!
            payment.startDay = String(arrStart![0])
            payment.startMonth = String(arrStart![1])
            payment.startYear = String(arrStart![2])
            if isRecuring {
                payment.endDay = String(arrEnd![0])
                payment.endMonth = String(arrEnd![1])
                payment.endYear = String(arrEnd![2])
            }
            payment.isRecuring = isRecuring
            payment.total = String(Double(txtAmount.text!)!)
            payment.assetParentID = assetParent.id
            
            assetParent.payments = [payment]
            LoadingManager.show(in: self)
            DatabaseRealmManager.shared.createAsset(asset: assetParent)
        } else {
            // create only payment
            let arrStart = lbStartDate.text?.split(separator: "/")
            let arrEnd = lbEndDate.text?.split(separator: "/")
            let payment = Payment()
            payment.name = txtName.text!
            payment.imageName = categorySelected.imageName
            payment.type = categorySelected.type
            payment.typeName = lbType.text!
            payment.startDay = String(arrStart![0])
            payment.startMonth = String(arrStart![1])
            payment.startYear = String(arrStart![2])
            if isRecuring {
                payment.endDay = String(arrEnd![0])
                payment.endMonth = String(arrEnd![1])
                payment.endYear = String(arrEnd![2])
            }
            payment.isRecuring = isRecuring
            payment.total = String(Double(txtAmount.text!)!)
            payment.assetParentID = assetParent.id
            
            LoadingManager.show(in: self)
            DatabaseRealmManager.shared.createPayment(payment: payment)
        }
    }
}

extension PaymentViewController {
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
            self.lbEndDate.text = nextMonth
            self.endDateSelected = date.convertStringToDate(nextMonth, "dd/MM/yyyy")
            self.minEndDate = date.convertStringToDate(nextMonth, "dd/MM/yyyy")
        }, cancel: { ActionStringCancelBlock in return }, origin: view.superview!.superview)
    }
    @objc func selectEndDate(_ sender: UITapGestureRecognizer) -> Void {
        self.view.endEditing(true)
        ActionSheetDatePicker.show(withTitle: "", datePickerMode: .date, selectedDate: endDateSelected , minimumDate: minEndDate, maximumDate: nil, doneBlock: { (picker, value, index) in
            let date = value as! Date
            let day = date.getDay()
            var dateString = date.convertDateToString(date, "dd/MM/yyyy")
            if (self.isRecuring) && Int(day)! > 28 {
                dateString.removeFirst()
                dateString.removeFirst()
                dateString = "28" + dateString
            }
            self.lbEndDate.text = dateString
            self.endDateSelected = date
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
