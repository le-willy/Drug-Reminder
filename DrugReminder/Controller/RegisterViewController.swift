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
    @IBOutlet weak var drugCategoryTextField: UITextField!
    @IBOutlet weak var numberOfDosesTextField: UITextField!
    @IBOutlet weak var time1TextField: UITextField!
    @IBOutlet weak var time2TextField: UITextField!
    @IBOutlet weak var time3TextField: UITextField!
    @IBOutlet weak var time4TextField: UITextField!

    
    var drugData = DrugModel()
    
    let category = ["category name","category name2","category name3","category name4"]
    let dosesPerDay = ["1回","2回","3回","4回"]
    
    let categoryPickerView = UIPickerView()
    let dosesPickerView = UIPickerView()
    
    var datePicker: UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.timeZone = .current
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 10
        datePicker.locale = Locale(identifier: "ja-JP")
        datePicker.preferredDatePickerStyle = .wheels

        return datePicker
    }
    
    var dateFormatter: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm"
        
        return dateFormat
    }
    
    
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .japanese)
        formatter.locale = .current
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        dosesPickerView.dataSource = self
        dosesPickerView.delegate = self
        
        categoryPickerView.tag = 1
        dosesPickerView.tag = 2
        
        configureDatePicker()
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        toolbar.setItems([doneButton], animated: true)
        
        drugNameTextField.inputAccessoryView = toolbar
        drugCategoryTextField.inputAccessoryView = toolbar
        numberOfDosesTextField.inputAccessoryView = toolbar
        time1TextField.inputAccessoryView = toolbar
        time2TextField.inputAccessoryView = toolbar
        time3TextField.inputAccessoryView = toolbar
        time4TextField.inputAccessoryView = toolbar
        
        drugCategoryTextField.inputView = categoryPickerView
        numberOfDosesTextField.inputView = dosesPickerView
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
            time1TextField.text = dateFormatter.string(from: sender.date)
        } else if sender == time2TextField.inputView {
            time2TextField.text = dateFormatter.string(from: sender.date)
        } else if sender == time3TextField.inputView {
            time3TextField.text = dateFormatter.string(from: sender.date)
        } else if sender == time4TextField.inputView {
            time4TextField.text = dateFormatter.string(from: sender.date)
        }
    }
    
    @IBAction func registerPressed(_ sender: UIBarButtonItem) {
        
        if let drugName = drugNameTextField.text {
            drugData.drugName = drugName
        }
        if let numberOfDoses = numberOfDosesTextField.text {
            drugData.numberOfDoses = numberOfDoses
        }
        if let time1 = time1TextField.text {
            var time = timeFormatter.date(from: time1)
            let dosingTime = DosingTime()
            dosingTime.at = time
            drugData.dosingTime.append(dosingTime)
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
            switch pickerView.tag {
            case 1:
                return category.count
            case 2:
                return dosesPerDay.count
            default:
                return 1
            }
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            switch pickerView.tag {
            case 1:
                return category[row]
            case 2:
                return dosesPerDay[row]
            default:
                return "error"
            }
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            switch pickerView.tag {
            case 1:
                drugCategoryTextField.text = category[row]
                drugCategoryTextField.resignFirstResponder()
            case 2:
                numberOfDosesTextField.text = dosesPerDay[row]
                numberOfDosesTextField.resignFirstResponder()
            default:
                return
            }
        }
    }
