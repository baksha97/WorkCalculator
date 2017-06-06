//
//  CalendarVC.swift
//  Fitkeeper
//
//  Created by Erik Myhrberg on 2017-05-02.
//  Copyright © 2017 Erik. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase

class CalendarVC: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {

    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var monthYear: UILabel!
    
    let displayRangeSegue = "displayRangeSegue"
    
    //MARK: FIREBASE
    let ref = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    let rUser = User(authData: (FIRAuth.auth()?.currentUser)!)
    
    //MARK: Array of WorkDays
    var workDays = [WorkDay]()
    var selectedDays = [WorkDay]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
        
        self.calendarView.visibleDates {[unowned self] (visibleDates: DateSegmentInfo) in
            self.setupViewsOfCalendar(from: visibleDates)
        }
        
        let userRef = FIRDatabase.database().reference(withPath: "users/\(rUser.userRef))/")
        
        userRef.observe(.value, with: { snapshot in
            self.load()
        })
        
       // calendarView.cell

    }
    
    private func load(){
        let runRef = FIRDatabase.database().reference(withPath: "users//\(rUser.userRef)/Workdays/")
        runRef.observe(.value, with: { snapshot in
            var currentWorkDays = [WorkDay]()
            for day in snapshot.children{
                let oldDay = WorkDay(snapshot: day as! FIRDataSnapshot)
                currentWorkDays.append(oldDay)
            }
            currentWorkDays.sort(by: { $0.timestamp.dateValue?.compare($1.timestamp.dateValue!) == ComparisonResult.orderedAscending})
            self.workDays = currentWorkDays;
            self.calendarView.reloadData()
            /*
            for day in self.workDays{
                self.calendarView.selectDates([day.timestamp.dateValue!])
            } */// doesn't work as intended because i want to show workview not selected view :/
        })
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == displayRangeSegue{
            let nextView = segue.destination as! SelectedDatesTableViewController
            nextView.workDays = selectedDays
        }
    }

    @IBAction func showSelectedDidTouch(_ sender: Any) {
        if selectedDays.first != nil{
            self.performSegue(withIdentifier: displayRangeSegue, sender: nil)
        }
    }
    
    func setupCalendarView() {
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, YYYY"
        monthYear.text = formatter.string(from: Date())
        calendarView.allowsMultipleSelection = true
        calendarView.scrollToDate(Date())
        calendarView.isRangeSelectionUsed = true
        //calendarView.visibleDates().outdates
        
        //validCell.workView.isHidden = false
    }
    
    /*
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {
        //(cell as? CellView)?.setupCellBeforeDisplay(cellState, date: date)
    }
    

    func setupCellBeforeDisplay(cellState: CellState, date: Date) {
        let dateString = self.calendarView.string(from: date)
        if workDays.contains(dateString.dateValue){  {
            print(eventDate, eventItem.date)
        } else {
            //makeBackgroundHidden()
        }
    }*/
    
    public func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        cell.workView.isHidden = true
        cell.dateLabel.alpha = 1
        cell.alpha = 1
        
        if cellState.isSelected {
            cell.selectedView.isHidden = false
        } else {
            cell.selectedView.isHidden = true
        }
        
        for day in workDays{
            if day.timestamp.dateValue?.mediumDescription == date.mediumDescription {
                cell.workView.isHidden = false
            }
        }
 
        if cellState.dateBelongsTo != .thisMonth {
            cell.alpha = 0.1
        }
        
        if date.shortDescription == Date().shortDescription{
            cell.dateLabel.textColor = UIColor.darkGray
        }
        return cell
        
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.isHidden = false
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateFormattedStr = formatter.string(from: date)
        print("Calendar selected date: \(dateFormattedStr)")
        
        for day in workDays{
            if day.timestamp.dateValue?.mediumDescription == date.mediumDescription {
                selectedDays.append(day)
            }
        }
        
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CustomCell else { return }
        validCell.selectedView.isHidden = true
        
        for (index, day) in selectedDays.enumerated() {
            if day.timestamp.dateValue?.mediumDescription == date.mediumDescription {
                selectedDays.remove(at: index)
            }
        }
        
    }
    
    public func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        guard let monthDate = visibleDates.monthDates.first?.date else { return }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let monthDateStr = formatter.string(from: monthDate)
        
        print("Calendar scrolled to: \(monthDateStr)")
        monthYear.text = monthDateStr
        
    }
    
    public func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let startDate = Date().oneMonthAgo! //formatter.date(from: "2011 01 01")!
        let endDate = Date()
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate, numberOfRows: 6, calendar: Calendar.current, generateInDates: .forAllMonths , generateOutDates: .tillEndOfGrid, firstDayOfWeek: .sunday)
        
        return parameters
    }
    
    
    
    //////
    
    func setupViewsOfCalendar(from visibleDates: DateSegmentInfo) {
        guard let startDate = visibleDates.monthDates.first?.date else {
            return
        }
        let month = Calendar.current.dateComponents([.month], from: startDate).month!
        let monthName = DateFormatter().monthSymbols[(month-1) % 12]
        // 0 indexed array
        let year = Calendar.current.component(.year, from: startDate)
        print(monthName + " " + String(year))
    }
    
    var rangeSelectedDates: [Date] = []
    func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        rangeSelectedDates = calendarView.selectedDates
        if let cellState = calendarView.cellStatus(at: point) {
            let date = cellState.date
            if !calendarView.selectedDates.contains(date) {
                let dateRange = calendarView.generateDateRange(from: calendarView.selectedDates.first ?? date, to: date)
                for aDate in dateRange {
                    if !rangeSelectedDates.contains(aDate) {
                        rangeSelectedDates.append(aDate)
                    }
                }
                calendarView.selectDates(from: rangeSelectedDates.first!, to: date, keepSelectionIfMultiSelectionAllowed: true)
            } else {
                let indexOfNewlySelectedDate = rangeSelectedDates.index(of: date)! + 1
                let lastIndex = rangeSelectedDates.endIndex
                let followingDay = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
                rangeSelectedDates.removeSubrange(indexOfNewlySelectedDate..<lastIndex)
            }
        }
        
        if gesture.state == .ended {
            rangeSelectedDates.removeAll()
        }
    }
}
