//
//  PushNotificationCenter.swift
//  BeChat
//
//  Created by saki on 2024/08/11.
//

import Foundation


class PushNotificationSender {
    func sendFCMNotification(payload: [String: Any]) {
        guard let url = URL(string: "https://fcm.googleapis.com/fcm/send") else { return }
        

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("AIzaSyBZ8Xg9oNv0WNL82GC577K5G3_XDHi6kAk", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: payload, options: [])
            request.httpBody = jsonData

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error sending FCM notification: \(error)")
                    return
                }
                print("FCM notification sent successfully!")
            }
            task.resume()
        } catch {
            print("Error serializing JSON: \(error)")
        }
    }

}
