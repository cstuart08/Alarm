//
//  SwitchTableViewCell.swift
//  Alarm
//
//  Created by Cameron Stuart on 8/5/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class SwitchTableViewCell: UITableViewCell {
    
    var alarm: Alarm?
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    @IBAction func switchValueChanged(_ sender: Any) {
    }
    
    func updateViews() {
        if let alarm = alarm {
            timeLabel.text = alarm.fireTimeAsString
            nameLabel.text = alarm.name
            alarmSwitch.isOn = alarm.enabled
        } else {
            timeLabel.text = "No time available."
            nameLabel.text = "No name available."
            alarmSwitch.isOn = false
        }
    }
}
