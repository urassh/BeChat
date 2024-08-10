//
//  Chat.swift
//  BeChat
//
//  Created by saki on 2024/08/10.
//

import Foundation
import FirebaseCore
import UIKit
struct Chat: Codable,Identifiable {
    let id: UUID
    let from_id: String
    let to_id: String
    let last_message: String
    let timestamp: Timestamp
    let last_image: String
    
    
}

