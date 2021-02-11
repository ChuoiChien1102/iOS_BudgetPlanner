//
//  TBPayment.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/17/20.
//

import Foundation
import Realm
import RealmSwift

class TBPayment : Object {
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var imageName: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var typeName: String = ""
    @objc dynamic var startDay: String = ""
    @objc dynamic var startMonth: String = ""
    @objc dynamic var startYear: String = ""
    @objc dynamic var endDay: String = ""
    @objc dynamic var endMonth: String = ""
    @objc dynamic var endYear: String = ""
    @objc dynamic var isRecuring: Bool = false
    @objc dynamic var total: String = ""
    
    @objc dynamic var createDate: Date = Date() //Saved date
    
    @objc dynamic var assetOwner: TBAsset?
    
    override class func primaryKey() -> String? {
        return "id"
    }

}
