//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Cameron Stuart on 8/5/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var alarmEnableDisableButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
}
    
    @IBAction func alarmEnableDisableButtonTapped(_ sender: Any) {
        if alarm?.enabled == true {
            alarmEnableDisableButton.setTitle("ALARM IS OFF", for: .normal)
            alarm?.enabled = false
            alarmIsOn = false
            AlarmController.sharedInstance.saveToPersistentStore()
        } else {
            alarmEnableDisableButton.setTitle("ALARM IS ON", for: .normal)
            alarm?.enabled = true
            alarmIsOn = true
            AlarmController.sharedInstance.saveToPersistentStore()
        }
    }
    
    @IBAction func alarmSaveButtonTapped(_ sender: Any) {
        
        guard let name = alarmNameTextField.text else { return }
        
        if let alarm = alarm {
            AlarmController.sharedInstance.update(alarm: alarm, fireDate: datePicker.date, name: name, enabled: alarmIsOn)
        } else {
            AlarmController.sharedInstance.addAlarm(fireDate: datePicker.date, name: name, enabled: alarmIsOn)
        }
        navigationController?.popViewController(animated: true)
    }
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var alarmIsOn: Bool = true
    
    func updateViews() {
        guard let alarm = alarm else { return }
        alarmIsOn = alarm.enabled
        alarmNameTextField.text = alarm.name
        datePicker.date = alarm.fireDate
        if alarm.enabled == true {
            alarmEnableDisableButton.setTitle("ALARM IS ON", for: .normal)
            alarmIsOn = true
        } else if alarm.enabled == false {
            alarmEnableDisableButton.setTitle("ALARM IS OFF", for: .normal)
            alarmIsOn = false
        }
    }
}
