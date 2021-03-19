//
//  MapViewController.swift
//  BudgetPlanner
//
//  Created by ChuoiChien on 12/22/20.
//

import UIKit
import QuartzCore

class MapViewController: BaseViewController {
    @IBOutlet weak var navigationBar: NavigationBar!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var viewLeft: UIView!
    
    @IBOutlet weak var lineChart: LineChart!
    @IBOutlet weak var widthViewLineChartContraint: NSLayoutConstraint!
    
    @IBOutlet weak var tableView: UITableView!
    
    var listPlan = [Plan]()
    var planSelected = Plan()
    var listMonthExpensesInYear1 = [MonthExpenses]()
    var listMonthExpensesInYear2 = [MonthExpenses]()
    var listMonthExpensesInYear3 = [MonthExpenses]()
    var listMonthExpensesInYear4 = [MonthExpenses]()
    var listMonthExpensesInYear5 = [MonthExpenses]()
    var listMonthExpensesInYear6 = [MonthExpenses]()
    var listMonthExpensesInYear7 = [MonthExpenses]()
    var listMonthExpensesInYear8 = [MonthExpenses]()
    var listMonthExpensesInYear9 = [MonthExpenses]()
    var listMonthExpensesInYear10 = [MonthExpenses]()
    var listMonthExpensesInYear11 = [MonthExpenses]()
    var listMonthExpensesInYear12 = [MonthExpenses]()
    var listMonthExpensesInYear13 = [MonthExpenses]()
    var listMonthExpensesInYear14 = [MonthExpenses]()
    
    var listAllMonthExpensesInMap = [MonthExpenses]()
    // simple line with custom x axis labels
    var xLabels = [String]()
    var listAllYearInMap = [String]()
    var indexYearSelected = 3
    var indexMonthSelected = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationBar.titleLabel.text = "Map"
        navigationBar.iconBtnLeft.isHidden = true
        navigationBar.leftButton.isHidden = true
        navigationBar.backLabel.isHidden = true
        navigationBar.rightButton.isHidden = true
        // init indexMonthSelected
        indexMonthSelected = Int(Date().getMonthNow())! - 1
        
        NotificationCenter.default.addObserver(self, selector: #selector(createPlanSuccess(_:)), name: NSNotification.Name(rawValue: NotificationCenterName.createPlanSuccess), object: nil)
        let listPastYear = Date().getArrayPastYearFromNow(toYear: -3)
        for year in listPastYear {
            listAllYearInMap.append(year)
        }
        listAllYearInMap.append(Date().getYearNow())
        let listFutureYear = Date().getArrayFutureYearFromNow(toYear: 10)
        for year in listFutureYear {
            listAllYearInMap.append(year)
        }
        
        // create xLabels
        for year in listAllYearInMap {
            let label1 = "Jan " + year
            let label2 = "Feb"
            let label3 = "Mar"
            let label4 = "Apr"
            let label5 = "May"
            let label6 = "Jun"
            let label7 = "Jul"
            let label8 = "Aug"
            let label9 = "Sep"
            let label10 = "Oct"
            let label11 = "Nov"
            let label12 = "Dec"
            xLabels.append(label1)
            xLabels.append(label2)
            xLabels.append(label3)
            xLabels.append(label4)
            xLabels.append(label5)
            xLabels.append(label6)
            xLabels.append(label7)
            xLabels.append(label8)
            xLabels.append(label9)
            xLabels.append(label10)
            xLabels.append(label11)
            xLabels.append(label12)
        }
        // tableView
        tableView.registerCellNib(HeaderSection.self)
        tableView.registerCellNib(DifferenceCell.self)
        tableView.registerCellNib(MonthTitleCell.self)
        tableView.registerCellNib(MonthDetailCell.self)
        tableView.registerCellNib(ViewExpensesCell.self)
        tableView.separatorStyle = .none
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listPlan = DatabaseRealmManager.shared.listAllPlan()
        lineChart.clearAll()
        if listPlan.count == 0 {
            Common.createDummyData()
            lineChart.animation.enabled = false
            lineChart.x.labels.visible = false
            lineChart.y.labels.visible = false
            lineChart.x.axis.visible = false
            lineChart.y.axis.visible = false
            lineChart.x.grid.visible = false
            lineChart.y.grid.visible = false
        } else {
            // set width LineChartView
            let widthLineChart = CGFloat(xLabels.count) * lineChart.widthPerItemX
            self.widthViewLineChartContraint.constant = (widthLineChart <= UIScreen.main.bounds.width) ? UIScreen.main.bounds.width : widthLineChart
            
            lineChart.x.grid.count = 5
            lineChart.y.grid.count = 5
            lineChart.x.labels.values = xLabels
            lineChart.viewYAxis = viewLeft
            lineChart.translatesAutoresizingMaskIntoConstraints = false
            lineChart.delegate = self
            // bin data tableView
            planSelected = listPlan.first!
            let listAsset = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: planSelected.id)
            listAllMonthExpensesInMap = getAllMonthExpensesInMap(listAsset: listAsset)
            listMonthExpensesInYear1 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[0]
            })
            listMonthExpensesInYear2 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[1]
            })
            listMonthExpensesInYear3 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[2]
            })
            listMonthExpensesInYear4 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[3]
            })
            listMonthExpensesInYear5 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[4]
            })
            listMonthExpensesInYear6 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[5]
            })
            listMonthExpensesInYear7 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[6]
            })
            listMonthExpensesInYear8 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[7]
            })
            listMonthExpensesInYear9 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[8]
            })
            listMonthExpensesInYear10 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[9]
            })
            listMonthExpensesInYear11 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[10]
            })
            listMonthExpensesInYear12 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[11]
            })
            listMonthExpensesInYear13 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[12]
            })
            listMonthExpensesInYear14 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[13]
            })
            // bin data view Map
            for plan in listPlan {
                let listAsset = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: plan.id)
                let data = binDataMap(listAsset: listAsset)
                lineChart.addLine(data)
            }
            scrollToCell(row: indexMonthSelected, section: indexYearSelected)
            tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    func drawYAxis() {
        let height = self.viewLeft.bounds.height
        let path = UIBezierPath()
        // draw x-axis
        let y0 = height - lineChart.y.axis.inset
        path.move(to: CGPoint(x: 45, y: y0))
        path.addLine(to: CGPoint(x: 1000, y: y0))
        // draw y-axis
        path.move(to: CGPoint(x: 45, y: height - lineChart.y.axis.inset))
        path.addLine(to: CGPoint(x: 45, y: lineChart.y.axis.inset))
        
        let layer = CAShapeLayer()
        layer.frame = self.viewLeft.bounds
        layer.path = path.cgPath
        
        layer.strokeColor = lineChart.x.axis.color.cgColor
        layer.fillColor = nil
        layer.lineWidth = 1
        self.viewLeft.layer.addSublayer(layer)
    }
    
    @objc func createPlanSuccess(_ notification: Notification) {
        lineChart.animation.enabled = true
        lineChart.x.labels.visible = true
        lineChart.y.labels.visible = true
        lineChart.x.axis.visible = true
        lineChart.y.axis.visible = true
        lineChart.x.grid.visible = true
        lineChart.y.grid.visible = true
        
        listPlan = DatabaseRealmManager.shared.listAllPlan()
        lineChart.clearAll()
        // set width LineChartView
        let widthLineChart = CGFloat(xLabels.count) * lineChart.widthPerItemX
        self.widthViewLineChartContraint.constant = (widthLineChart <= UIScreen.main.bounds.width) ? UIScreen.main.bounds.width : widthLineChart
        
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = xLabels
        lineChart.viewYAxis = viewLeft
        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        // bin data view Map
        for plan in listPlan {
            let listAsset = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: plan.id)
            let data = binDataMap(listAsset: listAsset)
            lineChart.addLine(data)
        }
        // bin data tableView
        planSelected = listPlan.first!
        let listAsset = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: planSelected.id)
        listAllMonthExpensesInMap = getAllMonthExpensesInMap(listAsset: listAsset)
        listMonthExpensesInYear1 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[0]
        })
        listMonthExpensesInYear2 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[1]
        })
        listMonthExpensesInYear3 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[2]
        })
        listMonthExpensesInYear4 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[3]
        })
        listMonthExpensesInYear5 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[4]
        })
        listMonthExpensesInYear6 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[5]
        })
        listMonthExpensesInYear7 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[6]
        })
        listMonthExpensesInYear8 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[7]
        })
        listMonthExpensesInYear9 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[8]
        })
        listMonthExpensesInYear10 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[9]
        })
        listMonthExpensesInYear11 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[10]
        })
        listMonthExpensesInYear12 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[11]
        })
        listMonthExpensesInYear13 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[12]
        })
        listMonthExpensesInYear14 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[13]
        })
        tableView.reloadData()
        scrollToCell(row: indexMonthSelected, section: indexYearSelected)
    }
}

extension MapViewController {
    func binDataMap(listAsset: [Asset]) -> [CGFloat] {
        var data = [CGFloat]()
        var dataMonthExpenses = [MonthExpenses]()
        for year in listAllYearInMap {
            var listAllPaymentInYear = [Payment]()
            for item in listAsset {
                let payments = DatabaseRealmManager.shared.listAllPaymentOfAsset(assetID: item.id)
                let listAllPaymentOfAssetInYear = payments.filter { (payment) -> Bool in
                    return checkPaymentIsInYear(pay: payment, year: year)
                }
                for pay in listAllPaymentOfAssetInYear {
                    listAllPaymentInYear.append(pay)
                }
            }
            let listMonthExpensesInYear = getAllMonthExpensesInYear(year: year, periousMonth: dataMonthExpenses.last, listAllPaymentInYear: listAllPaymentInYear)
            let listPoint = getDataPaymentInYear(year: year, periousMonth: dataMonthExpenses.last, listAllPaymentInYear: listAllPaymentInYear)
            for expenses in listMonthExpensesInYear {
                dataMonthExpenses.append(expenses)
            }
            for point in listPoint {
                data.append(point)
            }
        }
        
        return data
    }
    
    func getDataPaymentInYear(year: String, periousMonth: MonthExpenses?, listAllPaymentInYear: [Payment]) -> [CGFloat] {
        var data = [CGFloat]()
        
        let listPayment1 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "01", year: year))
        })
        let listPayment2 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "02", year: year))
        })
        let listPayment3 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "03", year: year))
        })
        let listPayment4 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "04", year: year))
        })
        let listPayment5 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "05", year: year))
        })
        let listPayment6 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "06", year: year))
        })
        let listPayment7 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "07", year: year))
        })
        let listPayment8 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "08", year: year))
        })
        let listPayment9 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "09", year: year))
        })
        let listPayment10 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "10", year: year))
        })
        let listPayment11 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "11", year: year))
        })
        let listPayment12 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "12", year: year))
        })
        var expenses1 = MonthExpenses()
        if periousMonth == nil {
            expenses1 = getExpensesInMonth(periousMonth: nil, indexMonth: "01", month: "January", year: year, listPayment: listPayment1)
        } else {
            expenses1 = getExpensesInMonth(periousMonth: periousMonth, indexMonth: "01", month: "January", year: year, listPayment: listPayment1)
        }
        let expenses2 = getExpensesInMonth(periousMonth: expenses1, indexMonth: "02", month: "February", year: year, listPayment: listPayment2)
        let expenses3 = getExpensesInMonth(periousMonth: expenses2, indexMonth: "03", month: "March", year: year, listPayment: listPayment3)
        let expenses4 = getExpensesInMonth(periousMonth: expenses3, indexMonth: "04", month: "April", year: year, listPayment: listPayment4)
        let expenses5 = getExpensesInMonth(periousMonth: expenses4, indexMonth: "05", month: "May", year: year, listPayment: listPayment5)
        let expenses6 = getExpensesInMonth(periousMonth: expenses5, indexMonth: "06", month: "June", year: year, listPayment: listPayment6)
        let expenses7 = getExpensesInMonth(periousMonth: expenses6, indexMonth: "07", month: "July", year: year, listPayment: listPayment7)
        let expenses8 = getExpensesInMonth(periousMonth: expenses7, indexMonth: "08", month: "August", year: year, listPayment: listPayment8)
        let expenses9 = getExpensesInMonth(periousMonth: expenses8, indexMonth: "09", month: "September", year: year, listPayment: listPayment9)
        let expenses10 = getExpensesInMonth(periousMonth: expenses9, indexMonth: "10", month: "October", year: year, listPayment: listPayment10)
        let expenses11 = getExpensesInMonth(periousMonth: expenses10, indexMonth: "11", month: "November", year: year, listPayment: listPayment11)
        let expenses12 = getExpensesInMonth(periousMonth: expenses11, indexMonth: "12", month: "December", year: year, listPayment: listPayment12)
        
        
        data.append(CGFloat(Double(expenses1.ending)!))
        data.append(CGFloat(Double(expenses2.ending)!))
        data.append(CGFloat(Double(expenses3.ending)!))
        data.append(CGFloat(Double(expenses4.ending)!))
        data.append(CGFloat(Double(expenses5.ending)!))
        data.append(CGFloat(Double(expenses6.ending)!))
        data.append(CGFloat(Double(expenses7.ending)!))
        data.append(CGFloat(Double(expenses8.ending)!))
        data.append(CGFloat(Double(expenses9.ending)!))
        data.append(CGFloat(Double(expenses10.ending)!))
        data.append(CGFloat(Double(expenses11.ending)!))
        data.append(CGFloat(Double(expenses12.ending)!))
        
        return data
    }
    
    func getAllMonthExpensesInMap(listAsset: [Asset]) -> [MonthExpenses] {
        var data = [MonthExpenses]()
        for year in listAllYearInMap {
            var listAllPaymentInYear = [Payment]()
            for item in listAsset {
                let payments = DatabaseRealmManager.shared.listAllPaymentOfAsset(assetID: item.id)
                let listAllPaymentOfAssetInYear = payments.filter { (payment) -> Bool in
                    return checkPaymentIsInYear(pay: payment, year: year)
                }
                for pay in listAllPaymentOfAssetInYear {
                    listAllPaymentInYear.append(pay)
                }
            }
            let listMonthExpensesInYear = getAllMonthExpensesInYear(year: year, periousMonth: data.last, listAllPaymentInYear: listAllPaymentInYear)
            for expenses in listMonthExpensesInYear {
                data.append(expenses)
            }
        }
        
        return data
    }
    
    func getAllMonthExpensesInYear(year: String, periousMonth: MonthExpenses?, listAllPaymentInYear: [Payment]) -> [MonthExpenses] {
        var data = [MonthExpenses]()
        
        let listPayment1 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "01", year: year))
        })
        let listPayment2 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "02", year: year))
        })
        let listPayment3 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "03", year: year))
        })
        let listPayment4 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "04", year: year))
        })
        let listPayment5 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "05", year: year))
        })
        let listPayment6 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "06", year: year))
        })
        let listPayment7 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "07", year: year))
        })
        let listPayment8 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "08", year: year))
        })
        let listPayment9 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "09", year: year))
        })
        let listPayment10 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "10", year: year))
        })
        let listPayment11 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "11", year: year))
        })
        let listPayment12 = listAllPaymentInYear.filter({ (payment) -> Bool in
            return (checkPaymentIsInMonth(pay: payment, month: "12", year: year))
        })
        var expenses1 = MonthExpenses()
        if periousMonth == nil {
            expenses1 = getExpensesInMonth(periousMonth: nil, indexMonth: "01", month: "January", year: year, listPayment: listPayment1)
        } else {
            expenses1 = getExpensesInMonth(periousMonth: periousMonth, indexMonth: "01", month: "January", year: year, listPayment: listPayment1)
        }
        let expenses2 = getExpensesInMonth(periousMonth: expenses1, indexMonth: "02", month: "February", year: year, listPayment: listPayment2)
        let expenses3 = getExpensesInMonth(periousMonth: expenses2, indexMonth: "03", month: "March", year: year, listPayment: listPayment3)
        let expenses4 = getExpensesInMonth(periousMonth: expenses3, indexMonth: "04", month: "April", year: year, listPayment: listPayment4)
        let expenses5 = getExpensesInMonth(periousMonth: expenses4, indexMonth: "05", month: "May", year: year, listPayment: listPayment5)
        let expenses6 = getExpensesInMonth(periousMonth: expenses5, indexMonth: "06", month: "June", year: year, listPayment: listPayment6)
        let expenses7 = getExpensesInMonth(periousMonth: expenses6, indexMonth: "07", month: "July", year: year, listPayment: listPayment7)
        let expenses8 = getExpensesInMonth(periousMonth: expenses7, indexMonth: "08", month: "August", year: year, listPayment: listPayment8)
        let expenses9 = getExpensesInMonth(periousMonth: expenses8, indexMonth: "09", month: "September", year: year, listPayment: listPayment9)
        let expenses10 = getExpensesInMonth(periousMonth: expenses9, indexMonth: "10", month: "October", year: year, listPayment: listPayment10)
        let expenses11 = getExpensesInMonth(periousMonth: expenses10, indexMonth: "11", month: "November", year: year, listPayment: listPayment11)
        let expenses12 = getExpensesInMonth(periousMonth: expenses11, indexMonth: "12", month: "December", year: year, listPayment: listPayment12)
        
        
        data.append(expenses1)
        data.append(expenses2)
        data.append(expenses3)
        data.append(expenses4)
        data.append(expenses5)
        data.append(expenses6)
        data.append(expenses7)
        data.append(expenses8)
        data.append(expenses9)
        data.append(expenses10)
        data.append(expenses11)
        data.append(expenses12)
        
        return data
    }
    
    func getExpensesInMonth(periousMonth: MonthExpenses?, indexMonth: String, month: String, year: String, listPayment: [Payment]) -> MonthExpenses {
        let item = MonthExpenses()
        item.indexMonth = indexMonth
        item.month = month
        item.year = year
        item.listPayment = listPayment
        
        var income = 0.0
        var expenses = 0.0
        for pay in listPayment {
            if Double(pay.total)! > 0 {
                income = income + Double(pay.total)!
            } else {
                expenses = expenses + Double(pay.total)!
            }
        }
        item.income = String(income)
        item.expenses = String(expenses)
        
        var starting = 0.0
        var ending = 0.0
        if periousMonth == nil {
            // month start => get balance default from local
            starting = UserDefaults.standard.double(forKey: KEY_BALANCE)
        } else {
            starting = Double(periousMonth!.ending)!
        }
        ending = starting + income + expenses
        item.starting = String(starting)
        item.ending = String(ending)
        return item
    }
    
    func checkPaymentIsInYear(pay: Payment, year: String) -> Bool {
        if !pay.isRecuring {
            if pay.startYear == year {
                return true
            } else {
                return false
            }
        } else {
            if pay.startYear <= year && year <= pay.endYear {
                return true
            } else {
                return false
            }
        }
    }
    
    func checkPaymentIsInMonth(pay: Payment, month: String, year: String) -> Bool {
        if !pay.isRecuring {
            if pay.startMonth == month  && pay.startYear == year {
                return true
            } else {
                return false
            }
        } else {
            let startDate = pay.startDay + "/" + pay.startMonth + "/" + pay.startYear
            let thisMonth = pay.startDay + "/" + month + "/" + year
            let endDate = pay.endDay + "/" + pay.endMonth + "/" + pay.endYear
            if Date().convertStringToDate(startDate, "dd/MM/yyyy") <= Date().convertStringToDate(thisMonth, "dd/MM/yyyy") && Date().convertStringToDate(thisMonth, "dd/MM/yyyy") <= Date().convertStringToDate(endDate, "dd/MM/yyyy") {
                return true
            } else {
                return false
            }
        }
    }
}

extension MapViewController: LineChartDelegate {
    func drawYLabels(_ listLabel: [UILabel]) {
        self.viewLeft.subviews.forEach { $0.removeFromSuperview() }
        for label in listLabel {
            viewLeft.addSubview(label)
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            let contentOffset = CGPoint(x: Int(self.lineChart.widthPerItemX) * (12 * (self.indexYearSelected) + self.indexMonthSelected), y: 0)
            self.scrollView.setContentOffset(contentOffset, animated: true)
        }
        drawYAxis()
    }
    
    func didSelectLine(_ lineIndex: Int) {
        planSelected = listPlan[lineIndex]
        let listAsset = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: planSelected.id)
        listAllMonthExpensesInMap = getAllMonthExpensesInMap(listAsset: listAsset)
        listMonthExpensesInYear1 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[0]
        })
        listMonthExpensesInYear2 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[1]
        })
        listMonthExpensesInYear3 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[2]
        })
        listMonthExpensesInYear4 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[3]
        })
        listMonthExpensesInYear5 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[4]
        })
        listMonthExpensesInYear6 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[5]
        })
        listMonthExpensesInYear7 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[6]
        })
        listMonthExpensesInYear8 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[7]
        })
        listMonthExpensesInYear9 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[8]
        })
        listMonthExpensesInYear10 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[9]
        })
        listMonthExpensesInYear11 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[10]
        })
        listMonthExpensesInYear12 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[11]
        })
        listMonthExpensesInYear13 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[12]
        })
        listMonthExpensesInYear14 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[13]
        })
        tableView.reloadData()
    }
    
    func didSelectDataPoint(_ index: Int, lineIndex: Int) {
        planSelected = listPlan[lineIndex]
        let listAsset = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: planSelected.id)
        listAllMonthExpensesInMap = getAllMonthExpensesInMap(listAsset: listAsset)
        listMonthExpensesInYear1 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[0]
        })
        listMonthExpensesInYear2 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[1]
        })
        listMonthExpensesInYear3 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[2]
        })
        listMonthExpensesInYear4 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[3]
        })
        listMonthExpensesInYear5 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[4]
        })
        listMonthExpensesInYear6 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[5]
        })
        listMonthExpensesInYear7 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[6]
        })
        listMonthExpensesInYear8 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[7]
        })
        listMonthExpensesInYear9 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[8]
        })
        listMonthExpensesInYear10 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[9]
        })
        listMonthExpensesInYear11 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[10]
        })
        listMonthExpensesInYear12 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[11]
        })
        listMonthExpensesInYear13 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[12]
        })
        listMonthExpensesInYear14 = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[13]
        })
        tableView.reloadData()
        scrollToCell(row: (index % 12), section: (index / 12))
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 14
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return listMonthExpensesInYear1.count
        case 1:
            return listMonthExpensesInYear2.count
        case 2:
            return listMonthExpensesInYear3.count
        case 3:
            return listMonthExpensesInYear4.count
        case 4:
            return listMonthExpensesInYear5.count
        case 5:
            return listMonthExpensesInYear6.count
        case 6:
            return listMonthExpensesInYear7.count
        case 7:
            return listMonthExpensesInYear8.count
        case 8:
            return listMonthExpensesInYear9.count
        case 9:
            return listMonthExpensesInYear10.count
        case 10:
            return listMonthExpensesInYear11.count
        case 11:
            return listMonthExpensesInYear12.count
        case 12:
            return listMonthExpensesInYear13.count
        case 13:
            return listMonthExpensesInYear14.count
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50))
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderSection") as! HeaderSection
        headerCell.frame = headerView.bounds
        let yearString = listAllYearInMap[section]
        headerCell.name.text = yearString
        headerView.addSubview(headerCell)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var item: MonthExpenses!
        switch indexPath.section {
        case 0:
            item = listMonthExpensesInYear1[indexPath.row]
            break
        case 1:
            item = listMonthExpensesInYear2[indexPath.row]
            break
        case 2:
            item = listMonthExpensesInYear3[indexPath.row]
            break
        case 3:
            item = listMonthExpensesInYear4[indexPath.row]
            break
        case 4:
            item = listMonthExpensesInYear5[indexPath.row]
            break
        case 5:
            item = listMonthExpensesInYear6[indexPath.row]
            break
        case 6:
            item = listMonthExpensesInYear7[indexPath.row]
            break
        case 7:
            item = listMonthExpensesInYear8[indexPath.row]
            break
        case 8:
            item = listMonthExpensesInYear9[indexPath.row]
            break
        case 9:
            item = listMonthExpensesInYear10[indexPath.row]
            break
        case 10:
            item = listMonthExpensesInYear11[indexPath.row]
            break
        case 11:
            item = listMonthExpensesInYear12[indexPath.row]
            break
        case 12:
            item = listMonthExpensesInYear13[indexPath.row]
            break
        case 13:
            item = listMonthExpensesInYear14[indexPath.row]
            break
        default:
            break
        }
        if item.tag == 0 {
            // cell title
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(MonthTitleCell.self)) as! MonthTitleCell
            cell.configCell(item: item)
            return cell
        } else if item.tag == 1 {
            // cell different
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(DifferenceCell.self)) as! DifferenceCell
            cell.configDifferenceCell(item: item)
            return cell
        } else if item.tag == 2 {
            // cell starting
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(MonthDetailCell.self)) as! MonthDetailCell
            cell.configStartingCell(item: item)
            return cell
        } else if item.tag == 3 {
            // cell ending
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(MonthDetailCell.self)) as! MonthDetailCell
            cell.configEndingCell(item: item)
            return cell
        } else if item.tag == 4 {
            // cell button
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(ViewExpensesCell.self)) as! ViewExpensesCell
            return cell
        }
        // default
        let cell = tableView.dequeueReusableCell(withIdentifier: String.className(MonthTitleCell.self)) as! MonthTitleCell
        cell.configCell(item: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 46
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var item: MonthExpenses!
        switch indexPath.section {
        case 0:
            item = listMonthExpensesInYear1[indexPath.row]
            break
        case 1:
            item = listMonthExpensesInYear2[indexPath.row]
            break
        case 2:
            item = listMonthExpensesInYear3[indexPath.row]
            break
        case 3:
            item = listMonthExpensesInYear4[indexPath.row]
            break
        case 4:
            item = listMonthExpensesInYear5[indexPath.row]
            break
        case 5:
            item = listMonthExpensesInYear6[indexPath.row]
            break
        case 6:
            item = listMonthExpensesInYear7[indexPath.row]
            break
        case 7:
            item = listMonthExpensesInYear8[indexPath.row]
            break
        case 8:
            item = listMonthExpensesInYear9[indexPath.row]
            break
        case 9:
            item = listMonthExpensesInYear10[indexPath.row]
            break
        case 10:
            item = listMonthExpensesInYear11[indexPath.row]
            break
        case 11:
            item = listMonthExpensesInYear12[indexPath.row]
            break
        case 12:
            item = listMonthExpensesInYear13[indexPath.row]
            break
        case 13:
            item = listMonthExpensesInYear14[indexPath.row]
            break
        default:
            break
        }
        if item.tag == 0 {
            // expand colapse cell
            item.isExpand = !item.isExpand
            if item.isExpand {
                // scroll cell to top
                scrollToCell(row: indexPath.row, section: indexPath.section)
                // add new row
                let itemDifferentAddNew = MonthExpenses()
                itemDifferentAddNew.tag = 1
                itemDifferentAddNew.indexMonth = item.indexMonth
                itemDifferentAddNew.month = item.month
                itemDifferentAddNew.year = item.year
                itemDifferentAddNew.income = item.income
                itemDifferentAddNew.expenses = item.expenses
                itemDifferentAddNew.starting = item.starting
                itemDifferentAddNew.ending = item.ending
                itemDifferentAddNew.ending = item.ending
                itemDifferentAddNew.isExpand = false
                itemDifferentAddNew.listPayment = item.listPayment
                
                let itemStartAddNew = MonthExpenses()
                itemStartAddNew.tag = 2
                itemStartAddNew.indexMonth = item.indexMonth
                itemStartAddNew.month = item.month
                itemStartAddNew.year = item.year
                itemStartAddNew.income = item.income
                itemStartAddNew.expenses = item.expenses
                itemStartAddNew.starting = item.starting
                itemStartAddNew.ending = item.ending
                itemStartAddNew.ending = item.ending
                itemStartAddNew.isExpand = false
                itemStartAddNew.listPayment = item.listPayment
                
                let itemEndingAddNew = MonthExpenses()
                itemEndingAddNew.tag = 3
                itemEndingAddNew.indexMonth = item.indexMonth
                itemEndingAddNew.month = item.month
                itemEndingAddNew.year = item.year
                itemEndingAddNew.income = item.income
                itemEndingAddNew.expenses = item.expenses
                itemEndingAddNew.starting = item.starting
                itemEndingAddNew.ending = item.ending
                itemEndingAddNew.ending = item.ending
                itemEndingAddNew.isExpand = false
                itemEndingAddNew.listPayment = item.listPayment
                
                let itemButtonAddNew = MonthExpenses()
                itemButtonAddNew.tag = 4
                itemButtonAddNew.indexMonth = item.indexMonth
                itemButtonAddNew.month = item.month
                itemButtonAddNew.year = item.year
                itemButtonAddNew.income = item.income
                itemButtonAddNew.expenses = item.expenses
                itemButtonAddNew.starting = item.starting
                itemButtonAddNew.ending = item.ending
                itemButtonAddNew.ending = item.ending
                itemButtonAddNew.isExpand = false
                itemButtonAddNew.listPayment = item.listPayment
                
                switch indexPath.section {
                case 0:
                    listMonthExpensesInYear1.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear1.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear1.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear1.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 1:
                    listMonthExpensesInYear2.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear2.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear2.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear2.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 2:
                    listMonthExpensesInYear3.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear3.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear3.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear3.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 3:
                    listMonthExpensesInYear4.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear4.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear4.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear4.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 4:
                    listMonthExpensesInYear5.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear5.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear5.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear5.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 5:
                    listMonthExpensesInYear6.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear6.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear6.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear6.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 6:
                    listMonthExpensesInYear7.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear7.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear7.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear7.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 7:
                    listMonthExpensesInYear8.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear8.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear8.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear8.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 8:
                    listMonthExpensesInYear9.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear9.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear9.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear9.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 9:
                    listMonthExpensesInYear10.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear10.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear10.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear10.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 10:
                    listMonthExpensesInYear11.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear11.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear11.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear11.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 11:
                    listMonthExpensesInYear12.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear12.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear12.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear12.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 12:
                    listMonthExpensesInYear13.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear13.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear13.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear13.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                case 13:
                    listMonthExpensesInYear14.insert(itemDifferentAddNew, at: indexPath.row + 1)
                    listMonthExpensesInYear14.insert(itemStartAddNew, at: indexPath.row + 2)
                    listMonthExpensesInYear14.insert(itemEndingAddNew, at: indexPath.row + 3)
                    listMonthExpensesInYear14.insert(itemButtonAddNew, at: indexPath.row + 4)
                    break
                default:
                    break
                }
                
                let listNewCell = [IndexPath.init(row: indexPath.row + 1, section: indexPath.section), IndexPath.init(row: indexPath.row + 2, section: indexPath.section), IndexPath.init(row: indexPath.row + 3, section: indexPath.section), IndexPath.init(row: indexPath.row + 4, section: indexPath.section)]
                self.tableView.beginUpdates()
                self.tableView.insertRows(at: listNewCell, with: .none)
                self.tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: indexPath.section)], with: .none)
                self.tableView.endUpdates()
            } else {
                // delete cell
                switch indexPath.section {
                case 0:
                    listMonthExpensesInYear1.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear1.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear1.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear1.remove(at: indexPath.row + 1)
                    break
                case 1:
                    listMonthExpensesInYear2.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear2.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear2.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear2.remove(at: indexPath.row + 1)
                    break
                case 2:
                    listMonthExpensesInYear3.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear3.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear3.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear3.remove(at: indexPath.row + 1)
                    break
                case 3:
                    listMonthExpensesInYear4.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear4.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear4.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear4.remove(at: indexPath.row + 1)
                    break
                case 4:
                    listMonthExpensesInYear5.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear5.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear5.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear5.remove(at: indexPath.row + 1)
                    break
                case 5:
                    listMonthExpensesInYear6.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear6.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear6.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear6.remove(at: indexPath.row + 1)
                    break
                case 6:
                    listMonthExpensesInYear7.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear7.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear7.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear7.remove(at: indexPath.row + 1)
                    break
                case 7:
                    listMonthExpensesInYear8.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear8.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear8.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear8.remove(at: indexPath.row + 1)
                    break
                case 8:
                    listMonthExpensesInYear9.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear9.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear9.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear9.remove(at: indexPath.row + 1)
                    break
                case 9:
                    listMonthExpensesInYear10.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear10.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear10.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear10.remove(at: indexPath.row + 1)
                    break
                case 10:
                    listMonthExpensesInYear11.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear11.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear11.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear11.remove(at: indexPath.row + 1)
                    break
                case 11:
                    listMonthExpensesInYear12.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear12.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear12.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear12.remove(at: indexPath.row + 1)
                    break
                case 12:
                    listMonthExpensesInYear13.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear13.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear13.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear13.remove(at: indexPath.row + 1)
                    break
                case 13:
                    listMonthExpensesInYear14.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear14.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear14.remove(at: indexPath.row + 1)
                    listMonthExpensesInYear14.remove(at: indexPath.row + 1)
                    break
                default:
                    break
                }
                
                let listDeleteCell = [IndexPath.init(row: indexPath.row + 1, section: indexPath.section), IndexPath.init(row: indexPath.row + 2, section: indexPath.section), IndexPath.init(row: indexPath.row + 3, section: indexPath.section), IndexPath.init(row: indexPath.row + 4, section: indexPath.section)]
                self.tableView.beginUpdates()
                self.tableView.deleteRows(at: listDeleteCell, with: .fade)
                self.tableView.reloadRows(at: [IndexPath.init(row: indexPath.row, section: indexPath.section)], with: .none)
                self.tableView.endUpdates()
            }
        }
        
        if item.tag == 4 {
            indexYearSelected = indexPath.section
            indexMonthSelected = indexPath.row - 4
            let vc = MonthViewController.newInstance()
            vc.expensesMonth = item
            vc.planParent = planSelected
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MapViewController {
    private func scrollToCell(row: Int, section: Int) {
//        for item in listAllMonthExpensesInMap {
//            item.isExpand = false
//        }
        let row = IndexPath(row: row, section: section)
        self.tableView.scrollToRow(at: row,
                                   at: .top,
                                   animated: true)
    }
}
