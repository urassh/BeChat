//
//  MessageStore.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class MessageStore : MessageProtocol {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let COLLECTION = "messages"
    private let STORAGE_URL = "gs://bechat-0811.appspot.com/image_message"
    
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
    
    internal func getTextMessage(id: String) async -> TextMessage? {
        let docRef = db.collection(COLLECTION).document(id)
        do {
            return try await docRef.getDocument(as: TextMessage.self)
        } catch {
            print("Error decoding city: \(error)")
        }
        
        return nil
    }
    
    internal func getImageMessage(id: String) async -> ImageMessage? {
        let ref = storage.reference(forURL: STORAGE_URL).child(id)
        
        guard let message: TextMessage = await getTextMessage(id: id) else { return nil }
        
        do {
            let data = try await withUnsafeThrowingContinuation { (continuation: UnsafeContinuation<Data, Error>) in
                ref.getData(maxSize: 100 * 1024 * 1024) { data, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else if let data = data {
                        continuation.resume(returning: data)
                    }
                }
            }
            
            let image = UIImage(data: data)
            
            return ImageMessage(id: message.id, from_id: message.from_id, to_id: message.to_id, image: image)
        } catch {
            print("Error occurred! : \(error)")
            return nil
        }
    }
    
    internal func sendText(with message: TextMessage) {
        do {
            try db.collection(COLLECTION).document(message.id.uuidString).setData(from: message)
        } catch {
            print("Error Writing Document: \(error)")
        }
    }
    
    private func sendImage(with message: ImageMessage) {
        guard let image = message.image else { return }
        
        let textMessage: TextMessage = message.toText()
        
        do {
            try db.collection(COLLECTION).document(message.id.uuidString).setData(from: textMessage)
            
            let ref = storage.reference(forURL: STORAGE_URL).child(message.id.uuidString)
            guard let jpegData = convertToJpegData(uiImage: image) else {
                print("画像の変換に失敗しました")
                return
            }
            ref.putData(jpegData as Data)
        } catch {
            print("Error Writing Document: \(error)")
        }
    }
    
    private func convertToJpegData(uiImage: UIImage) -> NSData? {
        return uiImage.jpegData(compressionQuality: 0.1) as? NSData
    }
}
