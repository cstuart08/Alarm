//
//  AlarmDetailTableViewController.swift
//  Alarm
//
//  Created by Cameron Stuart on 8/5/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmDetailTableViewController: UITableViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var alarmNameTextField: UITextField!
    @IBOutlet weak var alarmEnableDisableButton: UIButton!
    
    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    var newAlarm: Alarm?
    
    var alarmIsOn: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func alarmEnableDisableButtonTapped(_ sender: Any) {
        
        // toggle the button * alarmIsOn is keeping track of the state of the button
        alarmIsOn.toggle()
        // Updates button to reflect the state of alarm status.
        if alarmIsOn {
            alarmEnableDisableButton.setTitle("ALARM IS ON", for: .normal)
//            AlarmController.sharedInstance.scheduleNotifications(for: alarm)
        } else {
            // Updates button to reflect the state of alarm status.
            alarmEnableDisableButton.setTitle("ALARM IS OFF", for: .normal)
        }
        
        
        if let alarm = alarm {
            AlarmController.sharedInstance.toggleEnabled(for: alarm, enabled: alarmIsOn)
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
        } else {
            alarmEnableDisableButton.setTitle("ALARM IS ON", for: .normal)
            alarmIsOn = true
        }
    }
}

extension AlarmDetailTableViewController: AlarmScheduler {
    
}
