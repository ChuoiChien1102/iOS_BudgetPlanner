//
//  DatabaseRealmManager.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/17/20.
//

import Foundation
import Realm
import RealmSwift
import FCFileManager

class DatabaseRealmManager: NSObject {
        
    static let shared = DatabaseRealmManager()
    
    let realm = try! Realm()
    
    class func setup() {
        
        let dbConfig = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,
            
            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })
        
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = dbConfig
        
        var config = Realm.Configuration()
        FCFileManager.createDirectories(forPath: FolderPath.database)
        // Use the default directory, but replace the filename with the username
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(FolderPath.database)/chien.realm")
        
        // Set this as the configuration used for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
    
    //MARK:- Create
    
    //Create plan
    func createPlan( plan: Plan ) {
        
        let planDB = TBPlan()
        planDB.id = UUID.init().uuidString.lowercased()
        planDB.createDate = Date()
        planDB.name = plan.name
        for asset in plan.assets {
            let assetDB = TBAsset()
            assetDB.id = UUID.init().uuidString.lowercased()
            assetDB.createDate = Date()
            assetDB.name = asset.name
            assetDB.owner = planDB
            for payment in asset.payments {
                let paymentDB = TBPayment()
                paymentDB.id = UUID.init().uuidString.lowercased()
                paymentDB.createDate = Date()
                paymentDB.name = payment.name
                paymentDB.imageName = payment.imageName
                paymentDB.type = payment.type
                paymentDB.typeName = payment.typeName
                paymentDB.startDay = payment.startDay
                paymentDB.startMonth = payment.startMonth
                paymentDB.startYear = payment.startYear
                paymentDB.endDay = payment.endDay
                paymentDB.endMonth = payment.endMonth
                paymentDB.endYear = payment.endYear
                paymentDB.isRecuring = payment.isRecuring
                paymentDB.total = payment.total
                paymentDB.assetOwner = assetDB
                
                assetDB.payments.append(paymentDB)
                
                DispatchQueue.main.async {
                    try! self.realm.write {
                        print("Create payment success")
                        self.realm.add(paymentDB, update: .modified)
                    }
                }
            }
            planDB.assets.append(assetDB)
            
            DispatchQueue.main.async {
                try! self.realm.write {
                    print("Create asset success")
                    self.realm.add(assetDB, update: .modified)
                }
            }
        }
        DispatchQueue.main.async {
            try! self.realm.write {
                print("Create plan success")
                self.realm.add(planDB, update: .modified)
            }
            
            NotificationCenter.default.post(name: Notification.Name(NotificationCenterName.createPlanSuccess), object: nil)
        }
    }
    
    //Create asset
    func createAsset( asset: Asset ) {
        guard let planDB = realm.objects(TBPlan.self).filter({$0.id == asset.parentID}).first else { return }
        let assetDB = TBAsset()
        assetDB.id = UUID.init().uuidString.lowercased()
        assetDB.createDate = Date()
        assetDB.name = asset.name
        assetDB.owner = planDB
        
        for payment in asset.payments {
            let paymentDB = TBPayment()
            paymentDB.id = UUID.init().uuidString.lowercased()
            paymentDB.createDate = Date()
            paymentDB.name = payment.name
            paymentDB.imageName = payment.imageName
            paymentDB.type = payment.type
            paymentDB.typeName = payment.typeName
            paymentDB.startDay = payment.startDay
            paymentDB.startMonth = payment.startMonth
            paymentDB.startYear = payment.startYear
            paymentDB.endDay = payment.endDay
            paymentDB.endMonth = payment.endMonth
            paymentDB.endYear = payment.endYear
            paymentDB.isRecuring = payment.isRecuring
            paymentDB.total = payment.total
            paymentDB.assetOwner = assetDB
            
            assetDB.payments.append(paymentDB)
            
            DispatchQueue.main.async {
                try! self.realm.write {
                    print("Create payment success")
                    self.realm.add(paymentDB, update: .modified)
                }
            }
        }
        
        DispatchQueue.main.async {
            try! self.realm.write {
                print("Create asset success")
                self.realm.add(assetDB, update: .modified)
            }
            
            NotificationCenter.default.post(name: Notification.Name(NotificationCenterName.createAssetSuccess), object: nil)
        }
    }
    
    //Create payment
    func createPayment( payment: Payment ) {
        guard let assetDB = realm.objects(TBAsset.self).filter({$0.id == payment.assetParentID}).first else { return }
        let paymentDB = TBPayment()
        paymentDB.id = UUID.init().uuidString.lowercased()
        paymentDB.createDate = Date()
        paymentDB.name = payment.name
        paymentDB.imageName = payment.imageName
        paymentDB.type = payment.type
        paymentDB.typeName = payment.typeName
        paymentDB.startDay = payment.startDay
        paymentDB.startMonth = payment.startMonth
        paymentDB.startYear = payment.startYear
        paymentDB.endDay = payment.endDay
        paymentDB.endMonth = payment.endMonth
        paymentDB.endYear = payment.endYear
        paymentDB.isRecuring = payment.isRecuring
        paymentDB.total = payment.total
        paymentDB.assetOwner = assetDB
        
        DispatchQueue.main.async {
            try! self.realm.write {
                print("Create payment success")
                self.realm.add(paymentDB, update: .modified)
            }
            
            NotificationCenter.default.post(name: Notification.Name(NotificationCenterName.createPaymentSuccess), object: nil)
        }
    }
    
    //MARK:- Update
    // update Payment
    func editPayment(newPayment: Payment) {
        
        guard let paymentDB = realm.objects(TBPayment.self).filter({$0.id == newPayment.id}).first else { return }
        DispatchQueue.main.async {
            
            try! self.realm.write {
                paymentDB.name = newPayment.name
                paymentDB.imageName = newPayment.imageName
                paymentDB.type = newPayment.type
                paymentDB.typeName = newPayment.typeName
                paymentDB.startDay = newPayment.startDay
                paymentDB.startMonth = newPayment.startMonth
                paymentDB.startYear = newPayment.startYear
                paymentDB.endDay = newPayment.endDay
                paymentDB.endMonth = newPayment.endMonth
                paymentDB.endYear = newPayment.endYear
                paymentDB.isRecuring = newPayment.isRecuring
                paymentDB.total = newPayment.total
                print("Update payment success")
            }
            NotificationCenter.default.post(name: Notification.Name(NotificationCenterName.updatePaymentSuccess), object: nil)
        }

    }
    
    //MARK:- Delete
    func removePlan(id: String) {
        
        guard let plan = realm.objects(TBPlan.self).filter({$0.id == id}).first else { return }
        
        DispatchQueue.main.async {
            
            try! self.realm.write {
                print("Delete plan success")
                self.realm.delete(plan)
            }
            
            NotificationCenter.default.post(name: Notification.Name(NotificationCenterName.deletePlanSuccess), object: nil)
        }
    }
    
    //MARK:- List
    
    func listAllPlan() -> [Plan] {
        var listData:[Plan] = []
        let listPlan = realm.objects(TBPlan.self).sorted {$0.createDate > $1.createDate}
        
        for item in listPlan {
            let plan = Plan.init()
            plan.id = item.id
            plan.name = item.name
            
            listData.append(plan)
        }
        
        return listData
    }
    
    func listAllAssetOfPlan(planID: String) -> [Asset] {
        var listData:[Asset] = []
        let listPlan = realm.objects(TBPlan.self).filter {$0.id == planID}
        let planDB = listPlan.first
        let listAsset = realm.objects(TBAsset.self).filter {$0.owner == planDB}.sorted {$0.createDate > $1.createDate}
        
        for item in listAsset {
            let asset = Asset.init()
            asset.id = item.id
            asset.name = item.name
            asset.parentID = planID
            let listPayment = realm.objects(TBPayment.self).filter {$0.assetOwner == item}.sorted {$0.createDate > $1.createDate}
            var payments = [Payment]()
            for payDB in listPayment {
                let payment = Payment.init()
                payment.id = payDB.id
                payment.name = payDB.name
                payment.imageName = payDB.imageName
                payment.type = payDB.type
                payment.typeName = payDB.typeName
                payment.startDay = payDB.startDay
                payment.startMonth = payDB.startMonth
                payment.startYear = payDB.startYear
                payment.endDay = payDB.endDay
                payment.endMonth = payDB.endMonth
                payment.endYear = payDB.endYear
                payment.isRecuring = payDB.isRecuring
                payment.total = payDB.total
                payment.assetParentID = asset.id
                
                payments.append(payment)
            }
            asset.payments = payments
            listData.append(asset)
        }
        
        return listData
    }
    
    func listAllPaymentOfAsset(assetID: String) -> [Payment] {
        var listData:[Payment] = []
        let listAsset = realm.objects(TBAsset.self).filter {$0.id == assetID}
        let assetDB = listAsset.first
        let listPayment = realm.objects(TBPayment.self).filter {$0.assetOwner == assetDB}.sorted {$0.createDate > $1.createDate}
        
        for item in listPayment {
            let payment = Payment.init()
            payment.id = item.id
            payment.name = item.name
            payment.imageName = item.imageName
            payment.type = item.type
            payment.typeName = item.typeName
            payment.startDay = item.startDay
            payment.startMonth = item.startMonth
            payment.startYear = item.startYear
            payment.endDay = item.endDay
            payment.endMonth = item.endMonth
            payment.endYear = item.endYear
            payment.isRecuring = item.isRecuring
            payment.total = item.total
            payment.assetParentID = assetID
            
            listData.append(payment)
        }
        
        return listData
    }
}
