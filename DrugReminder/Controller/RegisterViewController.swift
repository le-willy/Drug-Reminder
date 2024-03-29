//
//  RegisterViewController.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import UIKit
import RealmSwift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var drugNameTextField: UITextField!
    @IBOutlet weak var numberOfDosesTextField: UITextField!
    @IBOutlet weak var time1TextField: UITextField!
    @IBOutlet weak var time2TextField: UITextField!
    @IBOutlet weak var time3TextField: UITextField!
    @IBOutlet weak var time4TextField: UITextField!
    
    
    var drugData = DrugModel()
    
    let dosesPerDay = ["1回".localized(),"2回".localized(),"3回".localized(),"4回".localized()]
    
    let dosesPickerView = UIPickerView()
    
    var datePicker: UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.timeZone = .current
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 10
        datePicker.locale = .current
//        datePicker.locale = Locale(identifier: "ja-JP")
        datePicker.preferredDatePickerStyle = .wheels
        
        return datePicker
    }
    
    var dateFormatterToCreatedDate: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.timeZone = .current
//        dateFormat.timeZone = TimeZone(identifier: "JST")
        dateFormat.dateFormat = "yyyy-MM-dd"

        return dateFormat
    }
    
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = .current
        formatter.timeZone = .current
//        formatter.calendar = Calendar(identifier: .japanese)
//        formatter.timeZone = TimeZone(identifier: "JST")
        formatter.locale = .current
        formatter.dateFormat = "HH:mm"
        return formatter
    }
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.overrideUserInterfaceStyle = .light
        view.backgroundColor = .yellow
        dosesPickerView.dataSource = self
        dosesPickerView.delegate = self
        
        configureDatePicker()
        setToolBar()
        
        numberOfDosesTextField.inputView = dosesPickerView
    }
    func setToolBar() {
        let toolBarRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35)
        let toolbar = UIToolbar(frame: toolBarRect)
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        drugNameTextField.inputAccessoryView = toolbar
        numberOfDosesTextField.inputAccessoryView = toolbar
        time1TextField.inputAccessoryView = toolbar
        time2TextField.inputAccessoryView = toolbar
        time3TextField.inputAccessoryView = toolbar
        time4TextField.inputAccessoryView = toolbar
    }
    
    func configureDatePicker() {
        let time1DatePicker = datePicker
        let time2DatePicker = datePicker
        let time3DatePicker = datePicker
        let time4DatePicker = datePicker
        
        time1DatePicker.addTarget(self, action: #selector(didChangeDatePicker), for: .valueChanged)
        time2DatePicker.addTarget(self, action: #selector(didChangeDatePicker), for: .valueChanged)
        time3DatePicker.addTarget(self, action: #selector(didChangeDatePicker), for: .valueChanged)
        time4DatePicker.addTarget(self, action: #selector(didChangeDatePicker), for: .valueChanged)
        

        time1TextField.inputView = time1DatePicker
        time2TextField.inputView = time2DatePicker
        time3TextField.inputView = time3DatePicker
        time4TextField.inputView = time4DatePicker
    }
    
    @objc func doneButtonPressed() {
        view.endEditing(true)
    }
    
    @objc func didChangeDatePicker(sender: UIDatePicker) {
        if sender == time1TextField.inputView {
            time1TextField.text = timeFormatter.string(from: sender.date)
        } else if sender == time2TextField.inputView {
            time2TextField.text = timeFormatter.string(from: sender.date)
        } else if sender == time3TextField.inputView {
            time3TextField.text = timeFormatter.string(from: sender.date)
        } else if sender == time4TextField.inputView {
            time4TextField.text = timeFormatter.string(from: sender.date)
        }
    }
    
    @IBAction func registerPressed(_ sender: UIBarButtonItem) {
        
        if let drugName = drugNameTextField.text {
            if drugName != "" {
            drugData.drugName = drugName
            
            drugData.dateCreated = Date()
            }
        }
        if let numberOfDoses = numberOfDosesTextField.text {
            if numberOfDoses != "" {
            drugData.numberOfDoses = numberOfDoses
            }
        }
        if let time1 = time1TextField.text {
            let time = timeFormatter.date(from: time1)
            let dosingTime = DosingTime()
            dosingTime.at = time
            
            if time1 != "" {
            drugData.dosingTime.append(dosingTime)
            }
        }
        if let time2 = time2TextField.text {
            let time = timeFormatter.date(from: time2)
            let dosingTime = DosingTime()
            dosingTime.at = time

            
            if time2 != "" {
            drugData.dosingTime.append(dosingTime)
            }
        }
        if let time3 = time3TextField.text {
            let time = timeFormatter.date(from: time3)
            let dosingTime = DosingTime()
            dosingTime.at = time

            
            if time3 != "" {
            drugData.dosingTime.append(dosingTime)
            }
        }
        if let time4 = time4TextField.text {
            let time = timeFormatter.date(from: time4)
            let dosingTime = DosingTime()
            dosingTime.at = time
            
            if time4 != "" {
            drugData.dosingTime.append(dosingTime)
            }
        }
        saveData(data: drugData)
        
        navigationController?.popViewController(animated: true)
    }
    
    func saveData(data: DrugModel) {
        do {
            try realm.write({
                realm.add(data)
            })
        } catch {
            print("Error saving: \(error)")
        }
    }
    
}

extension RegisterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dosesPerDay.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dosesPerDay[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        numberOfDosesTextField.text = dosesPerDay[row]
        numberOfDosesTextField.resignFirstResponder()
        
    }
}
