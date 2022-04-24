//
//  SettingsViewController.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit
import RealmSwift

class SettingsViewController: UIViewController {
    let realm = try! Realm()
    
//    var settingModel: [SettingsModel] = []
    var settingModel: Results<SettingsModel>?
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationLabel.text = "通知on/off"
    }
    
    //MARK: - Notification Test Area
    
    @IBAction func testButtonPressed(_ sender: UIBarButtonItem) {
        notificationTest()
    }
    
    func notificationTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello World"
        content.body = "My Notification Body, My Notification Body, My Notification Body"
        content.sound = .default
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("Notification error")
            }
        }
    }
    
    @IBAction func onOffSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("on")
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            print("off")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["id"])
        }
    }
    
        func loadData() {
            settingModel = realm.objects(SettingsModel.self)
        }
}


//extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        tableView.register(NotificationSwitchTableViewCell.uinib(), forCellReuseIdentifier: NotificationSwitchTableViewCell.indentifier)
//        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationSwitchTableViewCell.indentifier, for: indexPath) as! NotificationSwitchTableViewCell
//
//        return cell
//    }
//}

