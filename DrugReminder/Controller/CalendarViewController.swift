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
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    var drugDataArray: [DrugModel] = []
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .japanese)
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        calendarSetup()
        calendar.delegate = self
        calendar.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
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
        drugDataArray = Array(result)
    }
}

//MARK: - FSCalendarDelegate

extension CalendarViewController: FSCalendarDelegate {
    // You can do something when a date is selected
//    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
//        calendar.deselect(date)
//    }
    
}

//MARK: - FSCalendarDataSource

extension CalendarViewController: FSCalendarDataSource {
    // And event dot for some days
    func calendar(calendar: FSCalendar!, hasEventForDate date: NSDate!) -> Bool {
        return true
    }
}

//MARK: - TableView

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugDataArray[section].dosingTime.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drugDataArray[section].drugName
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let drugData = drugDataArray[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let dosingTime = Array(drugData.dosingTime)[indexPath.row].at {
            cell.textLabel?.text = timeFormatter.string(from: dosingTime)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
