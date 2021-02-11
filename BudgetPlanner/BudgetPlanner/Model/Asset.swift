//
//  Asset.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/2/20.
//  Copyright © 2020 VNPT. All rights reserved.
//

import UIKit

class Asset: NSObject {
    
    var id = ""
    var name = ""
    var parentID = ""
    var payments = [Payment]()
}
