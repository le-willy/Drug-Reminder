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
        view.backgroundColor = .yellow
        notificationLabel.text = "通知on/off"
        loadData()
    }
    
    @IBAction func onOffSwitch(_ sender: UISwitch) {
        if sender.isOn {
            print("on")
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            print("off")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["notification"])
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

