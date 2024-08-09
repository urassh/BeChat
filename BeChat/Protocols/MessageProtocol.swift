//
//  MessageProtocol.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import Foundation

protocol MessageProtocol {
  func send(with message: any Message, to user: AppUser)
  func getAll() -> [any Message]
  func get() -> any Message
}
