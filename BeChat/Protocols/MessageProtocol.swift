//
//  MessageProtocol.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import Foundation

protocol MessageProtocol {
    func send(with message: any Message)
    func fetchAll(for partnerId: String, completion: @escaping (Result<[TextMessage], Error>) -> Void)   
    func fetchChatAll(for userId: String, completion: @escaping (Result<[Chat], Error>) -> Void)
    func getTextMessage(id: String) async -> TextMessage?
    func getImageMessage(id: String) async -> ImageMessage?
}
