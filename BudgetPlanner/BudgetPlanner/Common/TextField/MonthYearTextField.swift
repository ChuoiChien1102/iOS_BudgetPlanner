//
//  MonthYearTextField.swift
//  VNPT-BRIS
//
//  Created by ERP-PM2-1174 on 4/17/20.
//  Copyright © 2020 VNPT. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

@objc protocol MonthYearTextFieldDelegate {
    func onSelected(item: MonthYearTextField)
    func onBeginSelect(item: MonthYearTextField)
}

class MonthYearTextField: UITextField {
    
    var monthYearTextFieldDelegate : MonthYearTextFieldDelegate?
    
    var arrMonth = [String]()
    var arrYear = [String]()
    // format dd/MM/yyyy
    var dateSelected = ""
    var minDate = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.delegate = self
    }
    
    func updateView(day: String, month: String, year: String) {
        let arrMin = minDate.split(separator: "/")
        let monthString = arrMin[1]
        let yearString = arrMin[2]
        if (yearString == year) && (Int(month)! < Int(monthString)!) {
            return
        }
        self.text = "\(day)/\(month)/\(year)"
    }
    
}

//MARK: UITextFieldDelegate
extension MonthYearTextField {
    func getBarButton(_ title : String) -> UIBarButtonItem{
        let customButton =  UIButton.init(type: UIButton.ButtonType.custom)
        customButton.setTitle(title, for: .normal)
        customButton.setTitleColor(.blue, for: .normal)
        customButton.frame = CGRect.init(x: 0, y: 5, width: 80, height: 32)
        return UIBarButtonItem.init(customView: customButton)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        //        UIApplication.topViewController()!.view.endEditing(true)
        self.monthYearTextFieldDelegate?.onBeginSelect(item: self)
        if dateSelected == ""  || minDate == "" {
            return false
        }
        let listFutureYear = Date().getArrayFutureYearFromNow(toYear: 10)
        let maxYear = listFutureYear.last
        let arrMin = minDate.split(separator: "/")
        let yearMin = String(arrMin[2])
        for i in Int(yearMin)!...Int(maxYear!)! {
            self.arrYear.append("\(i)")
        }
        
        for i in 1...12 {
            self.arrMonth.append(i < 10 ? "0\(i)" : "\(i)")
        }
        let arr = dateSelected.split(separator: "/")
        let monthSelected = String(arr[1])
        let yearSelected = String(arr[2])
        let indexYear = self.arrYear.firstIndex(of: yearSelected)
        let indexMonth = self.arrMonth.firstIndex(of: monthSelected)
        
        let cancelButton = getBarButton("Infinity")
        let picker = ActionSheetMultipleStringPicker(title: "", rows: [self.arrMonth, self.arrYear], initialSelection: [indexMonth!, indexYear!], doneBlock: { (picker, indexs, values) in
            print("values = \(String(describing: values))")
            print("indexes = \(String(describing: indexs))")
            print("picker = \(String(describing: picker))")
            
            if let data = values as? NSArray , data.count == 2 {
                self.updateView(day: String(arr[0]), month: "\(data[0])", year: "\(data[1])")
                self.dateSelected = "\(String(arr[0]))/\(data[0])/\(data[1])"
            }
            
            return
        }, cancel: { (picker) in
            self.text = KEY_INFINITY
        }, origin: self)
        picker?.setCancelButton(cancelButton)
        picker?.show()
        
        return false
    }
}
