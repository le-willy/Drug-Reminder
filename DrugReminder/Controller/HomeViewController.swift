//
//  ViewController.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit
import RealmSwift
import SwiftUI
import UserNotifications

class HomeViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    let userDefaults = UserDefaults.standard
    let calendar = Calendar(identifier: .gregorian)
    
    var drugDataArray: [DrugModel] = []
    var dosingTime: [DosingTime] = []
    var settingModel = SettingsViewController()
    
    var dayValue = 0
    var notificationIdentifier = 0
    var arrayNumber = 0
    var today = Date()
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.locale = .current
        dateFormatter.dateFormat = "MM月dd日".localized()
        return dateFormatter
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.calendar = .current
//        formatter.calendar = Calendar(identifier: .japanese)
//        formatter.timeZone = TimeZone(identifier: "JST")
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Notification Authorization
        let authOptions = UNAuthorizationOptions.init(arrayLiteral: .alert, .sound)
        
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { success, error in
            if let error = error {
                print("Notification error:\(error)")
            }
            if success == true {
                DispatchQueue.main.async {
                    self.settingModel.userDefaults.set(true, forKey: "mySwitchValue")
                }
            }
        }
        
        self.overrideUserInterfaceStyle = .light
        view.backgroundColor = .yellow
        dayLabel.text = dateFormatter.string(from: Date())
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addButtonPressed()

    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
        untoggleCheckMark()
    }
    
    
    @objc func addButtonSegue() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "addDrugView") as! RegisterViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func addButtonPressed() {
        let buttonAni: Selector = #selector(addButtonSegue)
        let setButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonAni)
        navigationItem.rightBarButtonItem = setButton
    }
    
    
    @IBAction func nextDayButton(_ sender: UIButton) {
        var dayAfter: Date {
            return Calendar.current.date(byAdding: .day, value: dayValue, to: Date())!
        }
        dayValue += 1
        let nextDay = dateFormatter.string(from: dayAfter)
        dayLabel.text = nextDay
        
        
        let startPoint = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: dayAfter)!
        let endPoint = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: dayAfter)!
        
        var record: Array<DrugModel> {
            return Array(try! Realm().objects(DrugModel.self).filter("dateCreated BETWEEN {%@, %@}", startPoint, endPoint))
        }
        
        drugDataArray = record
        
        let date = dateFormatter.string(from: today)
        if dayLabel.text == date {
            loadData()
        }
        
        tableView.reloadData()
        
        
    }
    
    
    @IBAction func previousDayButton(_ sender: UIButton) {
        var dayBefore: Date {
            return Calendar.current.date(byAdding: .day, value: dayValue, to: Date())!
        }
        dayValue -= 1
        
        let previousDay = dateFormatter.string(from: dayBefore)
        dayLabel.text = previousDay
        
        
        let startPoint = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: dayBefore)!
        let endPoint = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: dayBefore)!
        
        var record: Array<DrugModel> {
            return Array(try! Realm().objects(DrugModel.self).filter("dateCreated BETWEEN {%@, %@}", startPoint, endPoint))
        }
        
        drugDataArray = record
        
        let date = dateFormatter.string(from: today)
        if dayLabel.text == date {
            loadData()
        }
        tableView.reloadData()
        
    }

        
    func loadData() {
        let result = realm.objects(DrugModel.self)
        drugDataArray = Array(result)
        
    }
    
    func untoggleCheckMark() {
        if today == Date().zeroclock {
            dosingTime.forEach { item in
                item.done = false
                try! realm.write({
                    item.done = false
                })
            }
            tableView.reloadData()
        }
    }
    
    
    //MARK: - Notification Area
    
    func sendNotification(date: DateComponents) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "お薬リマインダー".localized()
        notificationContent.body = "お薬の飲み忘れはございませんか？".localized()
        
        drugDataArray.forEach { item in
            item.dosingTime.forEach { time in
                let identifier = time.at!
                let date4  = Calendar.current.dateComponents([.hour, .minute], from: time.at!)
                let trigger = UNCalendarNotificationTrigger(dateMatching: date4, repeats: false)
                let request = UNNotificationRequest(identifier: "\(identifier)", content: notificationContent, trigger: trigger)
                UNUserNotificationCenter.current().add(request)
                
                if time.done == true {
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(identifier)"])
                }
            }
        }
        let switchOnOff = userDefaults.bool(forKey: "mySwitchValue")
        
        if switchOnOff == false {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        }
    }
    
    func setNotifications() {
        drugDataArray.forEach { item in
            Array(item.dosingTime).forEach { dosingTime in
                if let components = dosingTime.at {
                    let result = Calendar.current.dateComponents(in: .current, from: components)
                    
                    sendNotification(date: result)
                }
            }
        }
    }
}


//MARK: - TableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "homeCell")
        if indexPath.section >= dosingTime.count {
            if let dosingTime = Array(drugData.dosingTime)[indexPath.row].at {
                cell.textLabel?.text = timeFormatter.string(from: dosingTime)
                cell.accessoryType = drugData.dosingTime[indexPath.row].done == true ? .checkmark: .none
                
                
                
                let currentHour = Calendar.current.dateComponents([.hour, .minute, .second], from: today)
                let midnight = Calendar.current.dateComponents([.hour, .minute, .second], from: dosingTime.zeroclock)
                
                if currentHour == midnight {
                    cell.accessoryType = .none
                    
                    try! realm.write({
                        drugData.dosingTime[indexPath.row].done = false
                    })
                }
                
                
                
            }
        }
        setNotifications()
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let drugData = drugDataArray[indexPath.section]
        
        try! realm.write({
            drugData.dosingTime[indexPath.row].done = !drugData.dosingTime[indexPath.row].done
        })
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let section = drugDataArray[indexPath.section]
        
        if let day = realm.objects(DrugModel.self).first {
            let childModel = realm.objects(DosingTime.self).filter("ANY parentCategory == %@", day)
            try! realm.write {
                realm.delete(childModel)
                realm.delete(section)
            }
        }
        drugDataArray.remove(at: indexPath.section)
        tableView.deleteSections([indexPath.section], with: .automatic)
    }
}

