//
//  CalendarViewController.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import Foundation
import UIKit
import RealmSwift
import FSCalendar

class CalendarViewController: UIViewController {
    
    @IBOutlet weak var calendar: FSCalendar!
    
    let realm = try! Realm()
    
    var drugModel: [DrugModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarSetup()
        calendar.delegate = self
        calendar.dataSource = self
    }
    
    func calendarSetup() {
        calendar.appearance.headerDateFormat = "MM月dd日"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.todayColor = .systemRed
        calendar.appearance.selectionColor = .systemYellow
        
        calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
        calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
        calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
        calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
        calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
        calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
        calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
        
        calendar.calendarWeekdayView.weekdayLabels[6].textColor = .blue
        calendar.calendarWeekdayView.weekdayLabels[0].textColor = .red
        
    }
    
    func loadData() {
        let result = realm.objects(DrugModel.self)
        drugModel = Array(result)
    }
}

extension CalendarViewController: FSCalendarDelegate {
    // You can do something when a date is selected
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.deselect(date)
    }
    
}

extension CalendarViewController: FSCalendarDataSource {
    // And event dot for some days
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        return true
    }
}
