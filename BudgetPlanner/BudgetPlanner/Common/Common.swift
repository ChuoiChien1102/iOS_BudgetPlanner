//
//  Common.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/18/20.
//

import UIKit
import Photos

class Common {
    
    static func createDummyData() {
        let plan = Plan()
        plan.name = "Plan married 2021"
        UserDefaults.standard.set(1000.0, forKey: KEY_BALANCE)
        DatabaseRealmManager.shared.createPlan(plan: plan)
    }
    
    static func listPaymentType() -> [CategoryModel]{
        var listData = [CategoryModel]()
        
        let pay1 = CategoryModel().create(imageName: "salary", type: CategoryType.salary, name: "Salary")
        let pay2 = CategoryModel().create(imageName: "deposite", type: CategoryType.deposite, name: "Deposite")
        let pay3 = CategoryModel().create(imageName: "gift", type: CategoryType.gift, name: "Gift")
        let pay4 = CategoryModel().create(imageName: "other", type: CategoryType.other, name: "Other")
        let pay5 = CategoryModel().create(imageName: "create", type: CategoryType.create, name: "Create")
        let pay6 = CategoryModel().create(imageName: "food", type: CategoryType.food, name: "Food")
        let pay7 = CategoryModel().create(imageName: "shop", type: CategoryType.shop, name: "Shop")
        let pay8 = CategoryModel().create(imageName: "clothes", type: CategoryType.clothes, name: "Clothes")
        let pay9 = CategoryModel().create(imageName: "beauty", type: CategoryType.beauty, name: "Beauty")
        let pay10 = CategoryModel().create(imageName: "health", type: CategoryType.health, name: "Health")
        let pay11 = CategoryModel().create(imageName: "home", type: CategoryType.home, name: "Home")
        let pay12 = CategoryModel().create(imageName: "baby", type: CategoryType.baby, name: "Baby")
        let pay13 = CategoryModel().create(imageName: "phone", type: CategoryType.phone, name: "Phone")
        let pay14 = CategoryModel().create(imageName: "education", type: CategoryType.education, name: "Education")
        let pay15 = CategoryModel().create(imageName: "pets", type: CategoryType.pets, name: "Pets")
        let pay16 = CategoryModel().create(imageName: "book", type: CategoryType.book, name: "Book")
        let pay17 = CategoryModel().create(imageName: "sport", type: CategoryType.sport, name: "Sport")
        let pay18 = CategoryModel().create(imageName: "games", type: CategoryType.games, name: "Games")
        let pay19 = CategoryModel().create(imageName: "taxi", type: CategoryType.taxi, name: "Taxi")
        let pay20 = CategoryModel().create(imageName: "spa", type: CategoryType.spa, name: "SPA")
        let pay21 = CategoryModel().create(imageName: "flowers", type: CategoryType.flowers, name: "Flowers")
        let pay22 = CategoryModel().create(imageName: "cafe", type: CategoryType.cafe, name: "Cafe")
        let pay23 = CategoryModel().create(imageName: "travel", type: CategoryType.travel, name: "Travel")
        let pay24 = CategoryModel().create(imageName: "bus", type: CategoryType.bus, name: "Bus")
        let pay25 = CategoryModel().create(imageName: "petrol", type: CategoryType.petrol, name: "Petrol")
        let pay26 = CategoryModel().create(imageName: "technics", type: CategoryType.technics, name: "Technics")
        let pay27 = CategoryModel().create(imageName: "funiture", type: CategoryType.funiture, name: "Funiture")
        let pay28 = CategoryModel().create(imageName: "cinema", type: CategoryType.cinema, name: "Cinema")
        let pay29 = CategoryModel().create(imageName: "credit", type: CategoryType.create, name: "Credit")
        
        listData.append(pay1)
        listData.append(pay2)
        listData.append(pay3)
        listData.append(pay4)
        listData.append(pay5)
        listData.append(pay6)
        listData.append(pay7)
        listData.append(pay8)
        listData.append(pay9)
        listData.append(pay10)
        listData.append(pay11)
        listData.append(pay12)
        listData.append(pay13)
        listData.append(pay14)
        listData.append(pay15)
        listData.append(pay16)
        listData.append(pay17)
        listData.append(pay18)
        listData.append(pay19)
        listData.append(pay20)
        listData.append(pay21)
        listData.append(pay22)
        listData.append(pay23)
        listData.append(pay24)
        listData.append(pay25)
        listData.append(pay26)
        listData.append(pay27)
        listData.append(pay28)
        listData.append(pay29)
        
        return listData
    }
    
    static func storeObjectToUserDefault(_ object: AnyObject, key: String) {
        let dataSave = NSKeyedArchiver.archivedData(withRootObject: object)
        UserDefaults.standard.set(dataSave, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func getObjectFromUserDefault(_ key: String) -> AnyObject? {
        if let object = UserDefaults.standard.object(forKey: key) {
            return NSKeyedUnarchiver.unarchiveObject(with: object as! Data) as AnyObject?
        }
        
        return nil
    }
    
    static func removeObjectForKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValueUserDefault() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
        defaults.synchronize()
    }
}
