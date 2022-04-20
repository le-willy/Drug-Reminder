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
    
    let section = ["1","2","3","4"]
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
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch count {
        case 0:
            tableView.register(DrugNameTableViewCell.nib(), forCellReuseIdentifier: DrugNameTableViewCell.identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: DrugNameTableViewCell.identifier, for: indexPath) as! DrugNameTableViewCell
            cell.nameLabel.text = drugDataArray[indexPath.row].drugName
            cell.categoryLabel.text = drugDataArray[indexPath.row].drugCatergory
            cell.dosesPerDayLabel.text = drugDataArray[indexPath.row].numberOfDoses
            print("FirstCell:\(count)")
            count += 1
            return cell
        case 1:
            tableView.register(Time1TableViewCell.nib(), forCellReuseIdentifier: Time1TableViewCell.identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: Time1TableViewCell.identifier, for: indexPath) as! Time1TableViewCell
            cell.time1Label.text = drugDataArray[indexPath.row].time1
            cell.accessoryType = drugDataArray[indexPath.row].done == true ? .checkmark: .none
            print("Time1Cell:\(count)")
            count += 1
            return cell
        case 2:
            tableView.register(Time2TableViewCell.nib(), forCellReuseIdentifier: Time2TableViewCell.identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: Time2TableViewCell.identifier, for: indexPath) as! Time2TableViewCell
            cell.time2Label.text = drugDataArray[indexPath.row].time2
            print("Time2Cell:\(count)")
            count += 1
            return cell
        case 3:
            tableView.register(Time3TableViewCell.nib(), forCellReuseIdentifier: Time3TableViewCell.identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: Time3TableViewCell.identifier, for: indexPath) as! Time3TableViewCell
            cell.time3Label.text = drugDataArray[indexPath.row].time3
            print("Time3Cell:\(count)")
            count += 1
            return cell
        case 4:
            tableView.register(Time4TableViewCell.nib(), forCellReuseIdentifier: Time4TableViewCell.identifier)
            let cell = tableView.dequeueReusableCell(withIdentifier: Time4TableViewCell.identifier, for: indexPath) as! Time4TableViewCell
            cell.time4Label.text = drugDataArray[indexPath.row].time4
            print("Time4Cell:\(count)")
            return cell
        default:
            return UITableViewCell()
        }
        
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        //        cell.textLabel?.text = drugDataArray[indexPath.row].drugName
        //        cell.textLabel?.text = drugDataArray[indexPath.row].drugCatergory
        //        cell.textLabel?.text = drugDataArray[indexPath.row].numberOfDoses
        //        cell.textLabel?.text = drugDataArray[indexPath.row].time1
        //        cell.textLabel?.text = drugDataArray[indexPath.row].time2
        //        cell.textLabel?.text = drugDataArray[indexPath.row].time3
        //        cell.textLabel?.text = drugDataArray[indexPath.row].time4
        //
        //        cell.accessoryType = drugDataArray[indexPath.row].done == true ? .checkmark: .none
        
//        return cell
        
        
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
    }
}


