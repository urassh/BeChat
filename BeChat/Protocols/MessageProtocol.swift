//
//  MessageProtocol.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import Foundation

protocol MessageProtocol {
    func send(with message: any Message)
    func getAll() async -> [TextMessage]
    func getTextMessage(id: String) async -> TextMessage?
    func getImageMessage(id: String) async -> ImageMessage?
}
