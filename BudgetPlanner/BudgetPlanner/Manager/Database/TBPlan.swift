//
//  TBPlan.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/17/20.
//

import Foundation
import Realm
import RealmSwift

class TBPlan : Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var createDate: Date = Date() //Saved date
    
    var assets = List<TBAsset>()
    override class func primaryKey() -> String? {
        return "id"
    }

}
