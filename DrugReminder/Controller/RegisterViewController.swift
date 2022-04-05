//
//  RegisterViewController.swift
//  DrugReminder
//
//  Created by Willy Sato on 2022/04/05.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var drugNameTextField: UITextField!
    @IBOutlet weak var drugCategoryTextField: UITextField!
    @IBOutlet weak var numberOfDosesTextField: UITextField!
    @IBOutlet weak var time1TextField: UITextField!
    @IBOutlet weak var time2TextField: UITextField!
    @IBOutlet weak var time3TextField: UITextField!
    @IBOutlet weak var time4TextField: UITextField!

    
    var drugData = [DrugData]()
    
    var category = ["category name","category name2","category name3","category name4"]
    var dosesPerDay = ["1", "2", "3" ,"4","5","6"]
    
    let categoryPickerView = UIPickerView()
    let dosesPickerView = UIPickerView()
    
    var datePicker: UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.timeZone = .current
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ja-JP")
        datePicker.preferredDatePickerStyle = .wheels

        return datePicker
    }
    
    var dateFormatter: DateFormatter {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "hh:mm"
        
        return dateFormat
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        time1TextField.delegate = self
        time2TextField.delegate = self
        time3TextField.delegate = self
        time4TextField.delegate = self
        
        
        drugNameTextField.delegate = self
        drugCategoryTextField.delegate = self
        numberOfDosesTextField.delegate = self

        categoryPickerView.dataSource = self
        categoryPickerView.delegate = self
        dosesPickerView.dataSource = self
        dosesPickerView.dataSource = self
        
        categoryPickerView.tag = 1
        dosesPickerView.tag = 2
        
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
    }

    @objc func doneButtonPressed() {
        time1TextField.text = dateFormatter.string(from: datePicker.date)
        time2TextField.text = dateFormatter.string(from: datePicker.date)
        time3TextField.text = dateFormatter.string(from: datePicker.date)

        view.endEditing(true)
    }
}


extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        drugCategoryTextField.inputView = categoryPickerView
        numberOfDosesTextField.inputView = dosesPickerView
        time1TextField.inputView = datePicker
        time2TextField.inputView = datePicker
        time3TextField.inputView = datePicker
        time4TextField.inputView = datePicker

        }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField == time1TextField {
            time1TextField.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        }
        if textField == time2TextField {
            time2TextField.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        }
        if textField == time3TextField {
            time3TextField.addTarget(self, action: #selector(timeChanged), for: .valueChanged)
        }
    }
    
    @objc func timeChanged(picker: UIDatePicker) {
        time1TextField.text = dateFormatter.string(from: datePicker.date)
        time2TextField.text = dateFormatter.string(from: datePicker.date)
        time3TextField.text = dateFormatter.string(from: datePicker.date)
    
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

