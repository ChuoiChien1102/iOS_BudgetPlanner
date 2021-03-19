//
//  Constants.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 5/9/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import UIKit

/*********************
 Check width, height Screen
 ********************/
let IS_IPHONE = UIDevice.current.userInterfaceIdiom == .phone
let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad

let WIDTH_DEVICE = UIScreen.main.bounds.size.width
let HEIGHT_DEVICE = UIScreen.main.bounds.size.height

let IS_IPHONE_5_5S_SE = (WIDTH_DEVICE == 320) && (HEIGHT_DEVICE == 568) && IS_IPHONE
let IS_IPHONE_6_6S_7_8 = (WIDTH_DEVICE == 375) && (HEIGHT_DEVICE == 667) && IS_IPHONE
let IS_IPHONE_6PLUS_7PLUS_8PLUS = (WIDTH_DEVICE == 414) && (HEIGHT_DEVICE == 736) && IS_IPHONE
let IS_IPHONE_X_XS = (WIDTH_DEVICE == 375) && (HEIGHT_DEVICE == 812) && IS_IPHONE
let IS_IPHONE_XR_XSMAX_11 = (WIDTH_DEVICE == 414) && (HEIGHT_DEVICE == 896) && IS_IPHONE

let KEY_BALANCE = "Balance"
let KEY_NUMBER_VARIANT = "Number_Variant"
let KEY_INFINITY = "∞"
let VALUE_INFINITY = "01/01/2999"


struct FolderPath {
    static let database = "database"
}


struct NotificationCenterName {
    static let createPlanSuccess = "createPlanSuccess"
    static let createAssetSuccess = "createAssetSuccess"
    static let createPaymentSuccess = "createPaymentSuccess"
    static let updatePaymentSuccess = "updatePaymentSuccess"
    static let updateAssetSuccess = "updateAssetSuccess"
    static let deletePlanSuccess = "deletePlanSuccess"
    static let deleteAssetSuccess = "deleteAssetSuccess"
    static let deletePaymentSuccess = "deletePaymentSuccess"
}

struct CategoryType {
    static let salary = "1"
    static let deposite = "2"
    static let gift = "3"
    static let other = "4"
    static let create = "5"
    static let food = "6"
    static let shop = "7"
    static let clothes = "8"
    static let beauty = "9"
    static let health = "10"
    static let home = "11"
    static let baby = "12"
    static let phone = "13"
    static let education = "14"
    static let pets = "15"
    static let book = "16"
    static let sport = "17"
    static let games = "18"
    static let taxi = "19"
    static let spa = "20"
    static let flowers = "21"
    static let cafe = "22"
    static let travel = "23"
    static let bus = "24"
    static let petrol = "25"
    static let technics = "26"
    static let funiture = "27"
    static let cinema = "28"
    static let credit = "29"
}
