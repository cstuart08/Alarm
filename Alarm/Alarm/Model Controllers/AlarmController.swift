//
//  AlarmController.swift
//  Alarm
//
//  Created by Cameron Stuart on 8/5/19.
//  Copyright © 2019 Cameron Stuart. All rights reserved.
//

import Foundation
import UserNotifications

protocol AlarmScheduler: class {
    func scheduleNotifications(for alarm: Alarm)
    func cancelNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    func scheduleNotifications(for alarm: Alarm) {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "Body"
        content.sound = UNNotificationSound.default
        
        let calendar = Calendar.current
        
        var dateComponent = DateComponents()
        dateComponent.hour = calendar.component(.hour, from: alarm.fireDate)
        dateComponent.minute = calendar.component(.minute, from: alarm.fireDate)
        dateComponent.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
        
        let identifier = alarm.uuid
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { (_) in
            print("User asked to get a local notification.")
        }
    }
    
    func cancelNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
        print("User cancelled local notification.")
    }
}

class AlarmController: AlarmScheduler {
    
    static let sharedInstance = AlarmController()
    
    var alarms: [Alarm] = []
    
    //    let mockAlarms: [Alarm] = [Alarm(fireDate: Date(), name: "Wake up", enabled: true), Alarm(fireDate: Date(), name: "Go to school", enabled: true), Alarm(fireDate: Date(), name: "Go to sleep", enabled: false)]
    //
    //    init() {
    //        self.alarms = self.mockAlarms
    //    }
    
    func addAlarm(fireDate: Date, name: String, enabled: Bool) {
        let newAlarm = Alarm(fireDate: fireDate, name: name, enabled: enabled)
        AlarmController.sharedInstance.alarms.append(newAlarm)
        newAlarm.enabled ? scheduleNotifications(for: newAlarm) : cancelNotifications(for: newAlarm)
        AlarmController.sharedInstance.saveToPersistentStore()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.name = name
        alarm.fireDate = fireDate
        alarm.enabled = enabled
        alarm.enabled ? scheduleNotifications(for: alarm) : cancelNotifications(for: alarm)
        AlarmController.sharedInstance.saveToPersistentStore()
    }
    
    func delete(alarm: Alarm) {
        guard let indexPathToDelete = alarms.firstIndex(of: alarm) else { return }
        self.alarms.remove(at: indexPathToDelete)
        AlarmController.sharedInstance.saveToPersistentStore()
    }
    
    func toggleEnabled(for alarm: Alarm, enabled: Bool) {
        alarm.enabled = enabled
        alarm.enabled ? scheduleNotifications(for: alarm) : cancelNotifications(for: alarm)
        saveToPersistentStore()
    }
    
    //MARK: - Persistance
    
    // Get the url where we are savign our data.
    func createFileURLForPersistence() -> URL {
        // Grab the users document directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        //Create the new fileURL on user's phone.
        let documentDirectory = urls[0]
        let filename = "alarm.json"
        let fullURL = documentDirectory.appendingPathComponent(filename)
        
        return fullURL
    }
    
    // Save the data at the url.
    func saveToPersistentStore() {
        // Create an instance of JSON Encoder
        let encoder = JSONEncoder()
        // Attempt to convert our playlist to JSON.
        do {
            let data = try encoder.encode(alarms)   // ** Note, anything that says "Throws" can return an error, and therefore needs to be in a do/catch block.
            // With the new json'd Playlist, save it to the user device.
            //            print(data)    // to print data to our debugger.
            //            print(String(data: data, encoding: .utf8)!)
            try data.write(to: createFileURLForPersistence())
            // Handle the error, if there is one
        } catch let error {
            print(error)
        }
    }
    
    // Fetch the data from the url.
    func loadFromPersistentStore() {
        // The data we want will be JSON, and I want it to be a Playlist.
        let decoder = JSONDecoder()
        // Decode the data.
        do {
            let data = try Data(contentsOf: createFileURLForPersistence())
            let alarmsArray = try decoder.decode([Alarm].self, from: data)
            alarms = alarmsArray
        } catch let error {
            print(error)
        }
    }
}


