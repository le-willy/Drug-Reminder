//
//  SettingsViewController.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let onOffSwitch = UISwitch()
    let userDefaults = UserDefaults.standard

        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        view.backgroundColor = .yellow
        
        tableView.dataSource = self
        tableView.delegate = self
        onOffSwitch.isOn = userDefaults.bool(forKey: "mySwitchValue")
        
    }
    
    @objc func switchAction(_ sender: UISwitch) {
//        userDefaults.set(sender.isOn, forKey: "mySwitchValue")
        if sender.isOn == true {
            userDefaults.set(true, forKey: "mySwitchValue")
        } else {
            userDefaults.set(false, forKey: "mySwitchValue")
        }
    }

}


extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "通知ON/OFF"
        
        onOffSwitch.addTarget(self, action: #selector(switchAction(_:)), for: .valueChanged)
        cell.accessoryView = onOffSwitch
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

