//
//  ViewController.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit
import RealmSwift
import SwiftUI

class HomeViewController: UIViewController {
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    var drugDataArray: [DrugModel] = []
    var dosingTime = DosingTime()
    
    var dayValue = 0
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "MM月dd日"
        
        return dateFormatter
    }
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
        formatter.calendar = Calendar(identifier: .japanese)
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dayLabel.text = dateFormatter.string(from: Date())
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addButtonPressed()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        loadData()
        tableView.reloadData()
        
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
//        let latestDate = realm.objects(DosingTime.self).sorted(byKeyPath: "at", ascending: false)
//        print(latestDate)

        
        
        tableView.reloadData()
    }
    
    
    @IBAction func previousDayButton(_ sender: UIButton) {
        var dayBefore: Date {
            return Calendar.current.date(byAdding: .day, value: dayValue, to: Date())!
        }
        dayValue -= 1
        
        let previousDay = dateFormatter.string(from: dayBefore)
        dayLabel.text = previousDay
        
        let result = realm.objects(DosingTime.self)
        let testResult = result.filter("at == %@", dayBefore)
        print(testResult)
    }
    
    func loadData() {
        let result = realm.objects(DrugModel.self)
        drugDataArray = Array(result)
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
        
        if let dosingTime = Array(drugData.dosingTime)[indexPath.row].at {
            cell.textLabel?.text = timeFormatter.string(from: dosingTime)
            cell.accessoryType = drugData.dosingTime[indexPath.row].done == true ? .checkmark: .none
        }
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
}


