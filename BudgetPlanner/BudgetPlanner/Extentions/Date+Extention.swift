//
//  Date+Extention.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 2/1/21.
//

import Foundation
import UIKit

extension Date {
    
    func getYearFromNow(year: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .year, value: year, to: self)!
    }
    
    func getDay() -> String {
        let day = Calendar(identifier: .gregorian).date(byAdding: .day, value: 0, to: self)!
        let calendar = Calendar(identifier: .gregorian)
        let dayComponent = calendar.component(.day, from: day)
        return String(dayComponent)
    }
    
    func getNextMonth() -> String {
        let todayOfNext = Calendar(identifier: .gregorian).date(byAdding: .day, value: 0, to: self)!
        let nextMonth = Calendar(identifier: .gregorian).date(byAdding: .month, value: 1, to: self)!
        let calendar = Calendar(identifier: .gregorian)
        let day = calendar.component(.day, from: todayOfNext)
        let month = calendar.component(.month, from: nextMonth)
        var yearOfNextMonth = Date()
        if String(month) == "1" {
            yearOfNextMonth = Calendar(identifier: .gregorian).date(byAdding: .year, value: 1, to: self)!
        } else {
            yearOfNextMonth = Calendar(identifier: .gregorian).date(byAdding: .year, value: 0, to: self)!
        }
        let year = calendar.component(.year, from: yearOfNextMonth)
        
        var dayString = ""
        var monthString = ""
        if Int(String(day))! < 10 {
            dayString = "0" + String(day)
        } else if Int(String(day))! > 28 {
            dayString = "28"
        } else {
            dayString = String(day)
        }
        if Int(String(month))! < 10 {
            monthString = "0" + String(month)
        } else {
            monthString = String(month)
        }
        return (dayString + "/" + monthString + "/" + String(year))
    }
    
    func getYearNow() -> String {
        let date = self.getYearFromNow(year: 0)
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: date)
        return String(year)
    }
    
    func getArrayFutureYearFromNow(toYear : Int) -> [String] {
        var arrayYear = [String]()
        
        var index = 1
        
        while index <= toYear {
            let date = self.getYearFromNow(year: index)
            let calendar = Calendar(identifier: .gregorian)
            
            let year = calendar.component(.year, from: date)
            arrayYear.append(String(year))
            index = index + 1
        }
        return arrayYear
    }
    func getArrayPastYearFromNow(toYear : Int) -> [String] {
        var arrayYear = [String]()
        
        var index = toYear
        while index <= -1 {
            let date = self.getYearFromNow(year: index)
            let calendar = Calendar(identifier: .gregorian)
            
            let year = calendar.component(.year, from: date)
            arrayYear.append(String(year))
            index = index + 1
        }
        return arrayYear
    }
    // Format Date
    func getStringFromDate( formatDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = formatDate
        return dateFormatter.string(from: self)
    }
    
    var startOfWeek: Date? {
        var gregorian = Calendar.current
        gregorian.locale = Locale(identifier: "ja_JP")
        gregorian.timeZone = TimeZone(secondsFromGMT: +9)!
        gregorian.firstWeekday = 2
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)) else { return nil }
        return sunday
        
    }
    
    func endOfWeek(_ date: Date) -> Date {
        var gregorian = Calendar.current
        gregorian.locale = Locale(identifier: "ja_JP")
        gregorian.timeZone = TimeZone(secondsFromGMT: +9)!
        guard let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)) else { return Date() }
        return gregorian.date(byAdding: .day, value: 7, to: sunday)!
    }
    
    // list date after current date
    func listDayAfterCurrentDate(_ currentDate: Date, _ toNumberDay: Int) -> [Date] {
        var arrDate: [Date] = []
        for i in 0..<toNumberDay {
            let interval = TimeInterval(60 * 60 * 24 * i)
            let newDate = currentDate.addingTimeInterval(interval)
            arrDate.append(newDate)
        }
        return arrDate
    }
    
    // convert date to string
    func convertDateToString(_ date: Date,_ formatter: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
//        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    // convert string to date
    func convertStringToDate(_ strDate: String,_ formatter: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatter
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: +9)!
        return dateFormatter.date(from: strDate)!
    }
    
    //
    func getStringDayAndDate(_ date: Date,_ format: String) -> (name: String, date: String) {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.locale = Locale(identifier: "ja_JP")
        dateFormatter1.timeZone = TimeZone(secondsFromGMT: +9)!
        dateFormatter1.dateFormat = "EEEE"
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = format
        return (dateFormatter1.string(from: date), dateFormatter2.string(from: date))
    }
    
    // convert date to milliseconds
    func convertDateToMilliseconds(_ date: Date) -> Double {
        return date.timeIntervalSince1970 * 1000
    }
    
    func addMonth(n: Int) -> Date {
        var cal = Calendar.current
        cal.locale = Locale(identifier: "ja_JP")
        cal.timeZone = TimeZone(secondsFromGMT: +9)!
        return cal.date(byAdding: .month, value: n, to: self)!
    }
    
    func startOfMonth() -> Date {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: +9)!
        return cal.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(secondsFromGMT: +9)!
        return cal.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func getYearFormDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: +9)
        dateFormatter.dateFormat = "YYYY"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func getMonthFormDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: +9)
        dateFormatter.dateFormat = "MMMM"
        let strMonth = dateFormatter.string(from: self)
        return strMonth
    }
    
    func yearMonthDayOfDate(_ date: Date) -> (year: String, month: String, day: String) {
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: +9)
        
        let year = String(calendar.component(.year, from: date))
        let month = String(calendar.component(.month, from: date))
        let day = String(calendar.component(.day, from: date))
        return (year, month, day)
    }
}

