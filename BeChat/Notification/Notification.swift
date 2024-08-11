//
//  Notification.swift
//  BeChat
//
//  Created by saki on 2024/08/11.
//

import Foundation
import UserNotifications
class Notification: Identifiable {
    func sendNotificationRequest(){
        let content = UNMutableNotificationContent()
        content.title = "通知のタイトル"
        content.body = "通知の内容です"

        let dateComponent = DateComponents(hour: 11, minute: 40)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }

}
