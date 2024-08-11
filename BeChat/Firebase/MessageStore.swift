//
//  MessageStore.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

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

    func fetchAll(
        for partnerId: String, completion: @escaping (Result<[TextMessage], Error>) -> Void
    ) {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            completion(.failure(NSError(domain: "NoUser", code: 401, userInfo: nil)))
            return
        }

        let query = db.collection(COLLECTION)
            .whereField("from_id", in: [currentUserId, partnerId])
            .whereField("to_id", in: [currentUserId, partnerId])
            .order(by: "timestamp", descending: true)  // タイムスタンプでソート

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
            .addSnapshotListener { querySnapshot, error in
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
                id: message.id, from_id: message.from_id, to_id: message.to_id, image: image,
                timestamp: Timestamp())
        }
        catch {
            print("Error occurred! : \(error)")
            return nil
        }
    }

    internal func sendText(with message: TextMessage) {
        do {
            try db.collection(COLLECTION).document(message.id.uuidString).setData(from: message)
            let chatData = Chat(
                id: UUID(), from_id: message.from_id, to_id: message.to_id,
                last_message: message.contents, timestamp: Timestamp(), last_image: "")

            db.collection(CHATS_COLLECTION)
                .document(message.from_id)
                .collection("user_chats")
                .document(message.to_id)

            try db.collection(CHATS_COLLECTION)
                .document(message.to_id)
                .collection("user_chats")
                .document(message.from_id)
                .setData(from: chatData, merge: true)
        }
        catch {
            print("Error Writing Document: \(error)")
        }
    }

    private func sendImage(with message: ImageMessage) {
        guard let image = message.image else { return }

        uploadImage(image: image, messageId: UUID()) { result in
            switch result {
            case .success(let imageURL):
                let message = TextMessage(
                    id: UUID(),
                    from_id: message.from_id,
                    to_id: message.to_id,
                    contents: imageURL.absoluteString,
                    message_type: "image",
                    timestamp: Timestamp()
                )

                do {
                    try self.db.collection(self.COLLECTION).document(message.id.uuidString).setData(
                        from: message)

                    let chatData = Chat(
                        id: UUID(), from_id: message.from_id, to_id: message.to_id,
                        last_message: "", timestamp: Timestamp(),
                        last_image: imageURL.absoluteString)

                    try self.db.collection(self.CHATS_COLLECTION).document(message.from_id)
                        .collection("user_chats").document(message.to_id).setData(from: chatData)
                    try self.db.collection(self.CHATS_COLLECTION).document(message.to_id)
                        .collection("user_chats").document(message.from_id).setData(from: chatData)
                }
                catch {
                    print("Error Writing Document: \(error)")
                }

            case .failure(let error):
                print("Error uploading image: \(error.localizedDescription)")
            }
        }
    }

    func uploadImage(
        image: UIImage, messageId: UUID, completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let storage = Storage.storage()
        let storageRef = storage.reference().child("images/\(messageId.uuidString).jpg")

        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(
                .failure(
                    NSError(
                        domain: "ImageError", code: 400,
                        userInfo: [NSLocalizedDescriptionKey: "Image data conversion failed"])))
            return
        }

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let downloadURL = url else {
                    completion(
                        .failure(
                            NSError(
                                domain: "URLRetrievalError", code: 500,
                                userInfo: [
                                    NSLocalizedDescriptionKey: "Failed to retrieve download URL"
                                ])))
                    return
                }

                completion(.success(downloadURL))
            }
        }
    }
    func getToken(for uid: String, completion: @escaping (Result<String, Error>) -> Void) {
        db.collection("users").document(uid).getDocument(){result,_ in
           let data = result?.data()
       let token = data?["fcm"]
       completion(.success(token as! String))
        }
    }

}
