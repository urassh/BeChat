//
//  Message.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import Foundation
import UIKit

protocol Message : Identifiable {
    func isImage() -> Bool
}

struct TextMessage : Message, Codable {
    let id: UUID
    let from_id: String
    let to_id: String
    let contents: String
    var message_type: String = "message"
    
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
    
    func toText() -> TextMessage {
        TextMessage(id: id, from_id: from_id, to_id: to_id, contents: "", message_type: "image")
    }
    
    func isImage() -> Bool {
        message_type == "image"
    }
}

