//
//  Message.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import Foundation
import UIKit
import FirebaseCore

protocol Message: Identifiable {
    func isImage() -> Bool
}

struct TextMessage: Message, Codable {
    let id: UUID
    let from_id: String
    let to_id: String
   var contents: String
    var message_type: String = "message"
    let timestamp: Timestamp

    func isImage() -> Bool {
        message_type == "image"
    }
}

struct ImageMessage: Message {
    let id: UUID
    let from_id: String
    let to_id: String
    let image: UIImage?
    var message_type: String = "image"
    let timestamp: Timestamp

    func toText() -> TextMessage {
        TextMessage(id: id, from_id: from_id, to_id: to_id, contents: "", message_type: "image", timestamp: Timestamp())
    }

    func isImage() -> Bool {
        message_type == "image"
    }
}
