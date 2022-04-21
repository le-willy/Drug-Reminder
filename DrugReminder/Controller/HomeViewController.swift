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
    //    var drugDataArray: Results<DrugModel>?
    var drugDataArray: [DrugModel] = []
    
    let sectionName = ["1","2","3","4"]
    var dayValue = 0
    var count = 0
    
    var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "MM月dd日"
        
        return dateFormatter
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
    }
    
    
    @IBAction func previousDayButton(_ sender: UIButton) {
        var dayBefore: Date {
            return Calendar.current.date(byAdding: .day, value: dayValue, to: Date())!
        }
        dayValue -= 1
        
        let previousDay = dateFormatter.string(from: dayBefore)
        dayLabel.text = previousDay
    }
    
    //    func loadData() {
    //        drugDataArray = realm.objects(DrugModel.self)
    //    }
    func loadData() {
        let result = realm.objects(DrugModel.self)
        drugDataArray = Array(result)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugDataArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return drugDataArray[section].drugName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return drugDataArray.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let drugData = drugDataArray[indexPath.row]

        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "homeCell")
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = drugData.numberOfDoses
            cell.detailTextLabel?.text = drugData.drugCatergory
        case 1:
            cell.textLabel?.text = drugData.time1
        case 2:
            cell.textLabel?.text = drugData.time2
        case 3:
            cell.textLabel?.text = drugData.time3
        default:
            return UITableViewCell()
        }
        cell.accessoryType = drugDataArray[indexPath.row].done == true ? .checkmark: .none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //                if let drugDone = drugDataArray[indexPath.row] {
        //                    do {
        //                        try realm.write({
        //                            drugDone.done = !drugDone.done
        //                        })
        //                    } catch {
        //                        print("Check error:\(error)")
        //                    }
        //                }
        let drugData = drugDataArray[indexPath.row]
        try! realm.write({
            drugData.done = !drugData.done
        })
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
}


