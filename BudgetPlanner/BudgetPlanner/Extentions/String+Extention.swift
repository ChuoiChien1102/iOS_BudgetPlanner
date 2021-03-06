//
//  String+.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 5/10/19.
//  Copyright © 2019 ChuoiChien. All rights reserved.
//

import Foundation
import UIKit

extension String {
    var length: Int {
        return self.count
    }
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func substring(_ from: Int) -> String {
        return self.substring(from: self.index(self.startIndex, offsetBy: from))
    }
    
    func convertNumberTelTo84(_ string: String) -> String {
        var str = string
        if str.first == "0" {
            str.removeFirst()
            str = "84" + str
        }
        return str
    }
    func toInt() -> Int {
        return Int(self) ?? 0
    }
    func addPoints(_ inputNumber: String) -> String {
        var number = inputNumber
        var count = 0
        while (count + 3) < inputNumber.length {
            number.insert(".", at: number.index(number.startIndex, offsetBy: inputNumber.length - 3 - count))
            count = count + 3
        }
        return number
    }
    
    func trimSpace () -> String {
        return  self.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
    }
    
    func index<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.lowerBound
    }
    
    func endIndex<S: StringProtocol>(of string: S, options: String.CompareOptions = []) -> Index? {
        range(of: string, options: options)?.upperBound
    }
}
