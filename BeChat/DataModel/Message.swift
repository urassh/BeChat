//
//  Message.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import Foundation
import UIKit

protocol Message: Identifiable {

}

struct TextMessage: Message, Codable {
  let id: UUID
  let from_id: String
  let to_id: String
  let contents: String
}

struct ImageMessage: Message {
  let id: UUID
  let from_id: String
  let to_id: String
  let image: UIImage?
}
