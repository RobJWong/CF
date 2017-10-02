//
//  ViewController.swift
//  LocalNotifications
//
//  Created by Hesham Abd-Elmegid on 3/7/17.
//  Copyright © 2017 CareerFoundry. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationsViewController: UIViewController {
    let notificationCenter = UNUserNotificationCenter.current()

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    @IBAction func requestNotificationsAuthorization(_ sender: Any) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notificationCenter.requestAuthorization(options: options) {(granted, error) in
            if granted {
                print ("Accepted permission")
            } else {
                print ("Did not accept permission")
            }
        }
    }
    
    @IBAction func checkNotificationsAuthorizationStatus(_ sender: Any) {
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                print("Notifications are authorized")
                if (settings.soundSetting ==  .disabled) {
                    print("Sound is disabled")
                }
            } else if settings.authorizationStatus == .denied {
                print ("Notifications have been denied")
            } else {
                print ("Notifications authorization dialog hasn't been shown yet")
            }
        }
    }
    
    @IBAction func showNotification(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = "OverdueTasksCategory"
        content.title = "Overdue tasks"
        content.body = "You have 5 overdue tasks"
        content.sound = UNNotificationSound.default()
        content.badge = 5
        
        //Bundle.main.path looks for a resource with the string identifier for resource and type
        guard let path = Bundle.main.path(forResource: "logo", ofType: "png") else {return}
        let url = URL(fileURLWithPath: path)

        do{
            let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
            content.attachments = [attachment]
        } catch{
            print("Could not load image")
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "OverdueTaskNotification", content: content, trigger: trigger)
        notificationCenter.add(request,withCompletionHandler: { (error) in
            if let error = error {
                print ("Couldn't add notification. Error: \(error)")
            }
        })
    }
}
