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
    var listMonthExpensesInYear = [MonthExpenses]()
    var listAllMonthExpensesInMap = [MonthExpenses]()
    // simple line with custom x axis labels
    var xLabels = [String]()
    var listAllYearInMap = [String]()
    var indexYearSelected = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationBar.titleLabel.text = "Map"
        navigationBar.iconBtnLeft.isHidden = true
        navigationBar.leftButton.isHidden = true
        navigationBar.backLabel.isHidden = true
        navigationBar.rightButton.isHidden = true
        
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
            let label1 = "Jan" + year
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
            listMonthExpensesInYear = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[indexYearSelected]
            })
            // bin data view Map
            for plan in listPlan {
                let listAsset = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: plan.id)
                let data = binDataMap(listAsset: listAsset)
                lineChart.addLine(data)
            }
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
        listMonthExpensesInYear = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[indexYearSelected]
        })

        tableView.reloadData()
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
            let contentOffset = CGPoint(x: Int(self.lineChart.widthPerItemX) * 12 * (self.indexYearSelected), y: 0)
            self.scrollView.setContentOffset(contentOffset, animated: true)
        }
        drawYAxis()
    }
    
    func didSelectLine(_ lineIndex: Int) {
        planSelected = listPlan[lineIndex]
        let listAsset = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: planSelected.id)
        listAllMonthExpensesInMap = getAllMonthExpensesInMap(listAsset: listAsset)
        listMonthExpensesInYear = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
            return monthExpenses.year == listAllYearInMap[indexYearSelected]
        })
        tableView.reloadData()
    }
    
    func didSelectDataPoint(_ index: Int, lineIndex: Int) {
        let indexOfPlanSelected = listPlan.firstIndex{$0 === planSelected}
        if indexOfPlanSelected != lineIndex {
            planSelected = listPlan[lineIndex]
            let listAsset = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: planSelected.id)
            listAllMonthExpensesInMap = getAllMonthExpensesInMap(listAsset: listAsset)
            listMonthExpensesInYear = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[indexYearSelected]
            })
            tableView.reloadData()
        } else {
            indexYearSelected = index/12
            planSelected = listPlan[lineIndex]
            let listAsset = DatabaseRealmManager.shared.listAllAssetOfPlan(planID: planSelected.id)
            listAllMonthExpensesInMap = getAllMonthExpensesInMap(listAsset: listAsset)
            listMonthExpensesInYear = listAllMonthExpensesInMap.filter({ (monthExpenses) -> Bool in
                return monthExpenses.year == listAllYearInMap[indexYearSelected]
            })
            tableView.reloadData()
            scrollToIndex(index: (index % 12))
        }
    }
}

extension MapViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if listMonthExpensesInYear.count == 0  {
            return 0
        }
        let month = listMonthExpensesInYear[section]
        if month.isExpand {
            return 6
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = listMonthExpensesInYear[indexPath.section]
        if indexPath.row == 0 {
            // Cell title
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(MonthTitleCell.self)) as! MonthTitleCell
            cell.configCell(item: item)
            
            return cell
        } else if indexPath.row == 1 {
            // Cell detail
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(MonthDetailCell.self)) as! MonthDetailCell
            cell.configIncomeCell(item: item)
            return cell
        } else if indexPath.row == 2 {
            // Cell detail
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(MonthDetailCell.self)) as! MonthDetailCell
            cell.configExpensesCell(item: item)
            
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(MonthDetailCell.self)) as! MonthDetailCell
            cell.configStartingCell(item: item)
            
            return cell
        } else if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(MonthDetailCell.self)) as! MonthDetailCell
            cell.configEndingCell(item: item)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String.className(ViewExpensesCell.self)) as! ViewExpensesCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 46
    }
    
    //    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    //        return 46
    //    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let item = listMonthExpensesInYear[indexPath.section]
            item.isExpand = !item.isExpand
            tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
        } else if indexPath.row == 5 {
            let item = listMonthExpensesInYear[indexPath.section]
            let vc = MonthViewController.newInstance()
            vc.expensesMonth = item
            vc.planParent = planSelected
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MapViewController {
    private func scrollToIndex(index: Int) {
        for item in listMonthExpensesInYear {
            item.isExpand = false
        }
        let item = listMonthExpensesInYear[index]
        item.isExpand = true
//        tableView.reloadSections(IndexSet(integer: index), with: .none)
        tableView.reloadData()
        
        let row = IndexPath(row: 0, section: index)
        self.tableView.scrollToRow(at: row,
                                   at: .top,
                                   animated: true)
    }
}
