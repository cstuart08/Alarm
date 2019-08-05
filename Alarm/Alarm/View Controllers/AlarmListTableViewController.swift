//
//  AlarmListTableViewController.swift
//  Alarm
//
//  Created by Cameron Stuart on 8/5/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import UIKit

class AlarmListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let alertController = UIAlertController(title: "Alert!", message: "Do you want to coninue?", preferredStyle: .alert)
        
        let yesContinue = UIAlertAction(title: "Yes", style: .default) { (_) in
            
        }
        
        alertController.addAction(yesContinue)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.sharedInstance.alarms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmListCell", for: indexPath) as? SwitchTableViewCell else { return UITableViewCell() }
        
        let specificAlarm = AlarmController.sharedInstance.alarms[indexPath.row]
        cell.alarm = specificAlarm
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.delete(alarm: alarm)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? AlarmDetailTableViewController else { return }
        if segue.identifier == "AlarmListToAlarmDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
                destinationVC.alarm = alarm
            }
        }
    }
}

extension AlarmListTableViewController: SwitchTableViewDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        guard let alarm = cell.alarm,
            let indexPath = tableView.indexPath(for: cell) else { return }
        AlarmController.sharedInstance.toggleEnabled(for: alarm)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
