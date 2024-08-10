//
//  MessageStore.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class MessageStore: MessageProtocol {
   
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let COLLECTION = "messages"    
    private let CHATS_COLLECTION = "chats"
    private let STORAGE_URL = "gs://bechat-0811.appspot.com/image_message"
    private var listener: ListenerRegistration?

    func send(with message: any Message) {
        if message is TextMessage {
            sendText(with: message as! TextMessage)
        }

        if message is ImageMessage {
            sendImage(with: message as! ImageMessage)
        }
    }

   

    func fetchAll(for partnerId: String, completion: @escaping (Result<[TextMessage], Error>) -> Void) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "NoUser", code: 401, userInfo: nil)))
            return
        }

        let query = db.collection(COLLECTION)
            .whereField("from_id", in: [currentUserId, partnerId])
            .whereField("to_id", in: [currentUserId, partnerId])
            .order(by: "timestamp", descending: true) // タイムスタンプでソート

        query.addSnapshotListener { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = querySnapshot?.documents else {
                completion(.success([]))
                return
            }

            let messages = documents.compactMap { queryDocumentSnapshot in
                try? queryDocumentSnapshot.data(as: TextMessage.self)
            }

            completion(.success(messages))
        }
    }

 
  

    func fetchChatAll(for userId: String, completion: @escaping (Result<[Chat], Error>) -> Void) {
        db.collection(CHATS_COLLECTION)
            .document(userId)
            .collection("user_chats")
            .order(by: "timestamp", descending: true)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let chats = documents.compactMap { document in
                    return try? document.data(as: Chat.self)
                }
                completion(.success(chats))
            }
    }

    func getTextMessage(id: String) async -> TextMessage? {
        let docRef = db.collection(COLLECTION).document(id)
        do {
            return try await docRef.getDocument(as: TextMessage.self)
        }
        catch {
            print("Error decoding city: \(error)")
        }

        return nil
    }

    func getImageMessage(id: String) async -> ImageMessage? {
        let ref = storage.reference(forURL: STORAGE_URL).child(id)

        guard let message: TextMessage = await getTextMessage(id: id) else { return nil }

        do {
            let data = try await withUnsafeThrowingContinuation {
                (continuation: UnsafeContinuation<Data, Error>) in
                ref.getData(maxSize: 100 * 1024 * 1024) { data, error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    }
                    else if let data = data {
                        continuation.resume(returning: data)
                    }
                }
            }

            let image = UIImage(data: data)

            return ImageMessage(
                id: message.id, from_id: message.from_id, to_id: message.to_id, image: image, timestamp: Timestamp())
        }
        catch {
            print("Error occurred! : \(error)")
            return nil
        }
    }

    internal func sendText(with message: TextMessage) {
        do {
            try db.collection(COLLECTION).document(message.id.uuidString).setData(from: message)
            let chatData =  Chat(id: UUID(), from_id: message.from_id, to_id: message.to_id, last_message: message.contents, timestamp: Timestamp())
                        
          try db.collection(CHATS_COLLECTION).document(message.from_id).collection("user_chats").document(message.to_id).setData(from: chatData)
                    
         try db.collection(CHATS_COLLECTION).document(message.to_id).collection("user_chats").document(message.from_id).setData(from: chatData)
        }
        catch {
            print("Error Writing Document: \(error)")
        }
    }

    private func sendImage(with message: ImageMessage) {
        guard let image = message.image else { return }

        let textMessage: TextMessage = message.toText()

        do {
            try db.collection(COLLECTION).document(message.id.uuidString).setData(from: textMessage)
            
            let chatData =  Chat(id: UUID(), from_id: textMessage.from_id, to_id: textMessage.to_id, last_message: "", timestamp: Timestamp())
                        
          try db.collection(CHATS_COLLECTION).document(message.from_id).collection("user_chats").document(message.to_id).setData(from: chatData)
                    
         try db.collection(CHATS_COLLECTION).document(message.to_id).collection("user_chats").document(message.from_id).setData(from: chatData)
            let ref = storage.reference(forURL: STORAGE_URL).child(message.id.uuidString)
            guard let jpegData = convertToJpegData(uiImage: image) else {
                print("画像の変換に失敗しました")
                return
            }
            ref.putData(jpegData as Data)
        }
        catch {
            print("Error Writing Document: \(error)")
        }
    }

    private func convertToJpegData(uiImage: UIImage) -> NSData? {
        return uiImage.jpegData(compressionQuality: 0.1) as? NSData
    }

    deinit {
        listener?.remove()
    }
}
