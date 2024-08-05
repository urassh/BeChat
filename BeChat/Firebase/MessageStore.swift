//
//  MessageStore.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import Foundation
import FirebaseFirestore

class MessageStore : MessageProtocol {
    private let db = Firestore.firestore()
    private let COLLECTION = "messages"
    
    func send(with message: any Message) {
        if message is TextMessage {
            sendText(with: message as! TextMessage)
        }
        
        if message is ImageMessage {
            sendImage(with: message as! ImageMessage)
        }
    }
    
    func getAll() async -> [TextMessage] {
        let ref = db.collection(COLLECTION)
        
        do {
            return try await ref.getDocuments()
                        .documents
                        .compactMap { try? $0.data(as: TextMessage.self)}
        } catch {
            print("Error Writing Document: \(error)")
        }
        
        return []
    }
    
    func getTextMessage(id: String) async -> TextMessage? {
        let docRef = db.collection(COLLECTION).document(id)
        do {
            return try await docRef.getDocument(as: TextMessage.self)
        } catch {
            print("Error decoding city: \(error)")
        }
        
        return nil
    }
    
    func getImageMessage(id: String) async -> ImageMessage? {
        return nil
    }
    
    private func sendText(with message: TextMessage) {
        do {
            try db.collection(COLLECTION).document(message.id.uuidString).setData(from: message)
        } catch {
            print("Error Writing Document: \(error)")
        }
    }
    
    private func sendImage(with message: ImageMessage) {
        let textMessage: TextMessage = message.toText()
        
        do {
            try db.collection(COLLECTION).document(message.id.uuidString).setData(from: textMessage)
            
            //TODO: ここにStorageに保存する処理を実装する。
        } catch {
            print("Error Writing Document: \(error)")
        }
    }
}
