//
//  MonthExpenses.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/2/20.
//  Copyright © 2020 VNPT. All rights reserved.
//

import UIKit

class MonthExpenses: NSObject {
    var tag = 0 // 0 is title cell, 1 is different cell, 2 is display starting, ending, 3 is button viewExpenses
    var indexMonth = ""
    var month = ""
    var year = ""
    var income = ""
    var expenses = ""
    var starting = ""
    var ending = ""
    var isExpand = false
    var listPayment = [Payment]()
}
