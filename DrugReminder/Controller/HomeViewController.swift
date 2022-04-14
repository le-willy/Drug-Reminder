//
//  ViewController.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addDrugButton: UIBarButtonItem!
    
    let realm = try! Realm()
    var drugDataArray: Results<DrugModel>?
    
    let section = ["1","2","3","4"]
    var dayValue = 0
    var tableViewCount = 0
    
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
    
    func loadData() {
        drugDataArray = realm.objects(DrugModel.self)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return drugDataArray?.count ?? 4
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableViewCount {
        case 0:
            tableView.register(UINib(nibName: "DrugNameTableViewCell", bundle: nil), forCellReuseIdentifier: "drugName")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "drugName", for: indexPath) as! DrugNameTableViewCell
            cell.nameLabel.text = drugDataArray?[indexPath.row].drugName
            cell.categoryLabel.text = drugDataArray?[indexPath.row].drugCatergory
            cell.dosesPerDayLabel.text = drugDataArray?[indexPath.row].numberOfDoses
            tableViewCount += 1
           return cell
            
        case 1:
            tableView.register(UINib(nibName: "Time1TableViewCell", bundle: nil), forCellReuseIdentifier: "time1")
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "time1", for: indexPath) as! Time1TableViewCell
            cell.timeLabel.text = drugDataArray?[indexPath.row].time1
            return cell
        default:
            return UITableViewCell()
        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
//        if let drugData = drugDataArray?[indexPath.row] {
//            cell.textLabel?.text = drugData.drugName
//            cell.textLabel?.text = drugData.drugCatergory
//            cell.textLabel?.text = drugData.numberOfDoses
//            cell.accessoryType = drugData.done == true ? .checkmark: .none
//
//            return cell
//        }
//
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let drugDone = drugDataArray?[indexPath.row] {
            do {
                try realm.write({
                    drugDone.done = !drugDone.done
                })
            } catch {
                print("Check error:\(error)")
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


