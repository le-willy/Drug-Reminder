//
//  SettingsViewController.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        tableView.dataSource = self
        tableView.delegate = self
    }

}


extension SettingsViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.register(UINib(nibName: "NotificationButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "button")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "button", for: indexPath) as! NotificationButtonTableViewCell

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

