//
//  TBAsset.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/17/20.
//

import Foundation
import Realm
import RealmSwift

class TBAsset : Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var createDate: Date = Date() //Saved date
    
    var payments = List<TBPayment>()
    @objc dynamic var owner: TBPlan?
    
    override class func primaryKey() -> String? {
        return "id"
    }

}
