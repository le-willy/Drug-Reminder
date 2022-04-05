//
//  ViewController.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addDrugButton: UIBarButtonItem!
    
    var drugData = [DrugData]()
    
    let today = Calendar.current
    let date = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        addButtonPressed()
        
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
        let nextDay = today.date(byAdding: .day, value: 1, to: today.startOfDay(for: date))
        print(nextDay)
    }
        
    
    @IBAction func previousDayButton(_ sender: UIButton) {
        let previousDay = today.date(byAdding: .day, value: -1, to: today.startOfDay(for: date))
        print(previousDay)
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath)
        cell.textLabel?.text = "hello"
        
        return cell
    }
}


