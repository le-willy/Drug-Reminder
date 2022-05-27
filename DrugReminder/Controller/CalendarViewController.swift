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
        formatter.timeZone = TimeZone(identifier: "JST")
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .yellow
        loadData()

        calendarSetup()
        calendar.delegate = self
        calendar.dataSource = self
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {

        tableView.reloadData()

    }
    
    func calendarSetup() {
        calendar.appearance.headerDateFormat = "MM月dd日"
        calendar.appearance.headerTitleColor = .black
        calendar.appearance.todayColor = .systemRed
        calendar.appearance.selectionColor = .systemBlue
        
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
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let calendarComp = Calendar(identifier: .gregorian)
        let startPoint = calendarComp.date(bySettingHour: 0, minute: 0, second: 0, of: date)!
        let endPoint = calendarComp.date(bySettingHour: 23, minute: 59, second: 59, of: date)!
        
        var record: Array<DrugModel> {
            return Array(try! Realm().objects(DrugModel.self).filter("dateCreated BETWEEN {%@, %@}", startPoint, endPoint))
        }
        
        drugDataArray = record
        tableView.reloadData()
        
//        calendar.deselect(date)
        
    }
    
}

//MARK: - FSCalendarDataSource

extension CalendarViewController: FSCalendarDataSource {
    // And event dot for some days
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let list = drugDataArray.map({ $0.dateCreated?.zeroclock })
        let result = list.contains(date.zeroclock)
        return result ? 1 : 0
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return drugDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let drugData = drugDataArray[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let dosingTime = Array(drugData.dosingTime)[indexPath.row].at {
            cell.textLabel?.text = timeFormatter.string(from: dosingTime)
            cell.accessoryType = drugData.dosingTime[indexPath.row].done == true ? .checkmark: .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
