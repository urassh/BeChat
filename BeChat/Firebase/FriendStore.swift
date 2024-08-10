//
//  FriendStore.swift
//  BeChat
//
//  Created by saki on 2024/08/11.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
class FriendStore: FriendProtocol{
    private let db = Firestore.firestore()
    func searchUser(by uid: String, completion: @escaping (Result<AppUser, Error>) -> Void) {
        let userRef = db.collection("users").document(uid)
        
        userRef.getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists, let user = try? document.data(as: AppUser.self) else {
                completion(.failure(NSError(domain: "UserNotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                return
            }
            
            completion(.success(user))
        }
    }
    
    func addFriend(userId: String, friend: AppUser, completion: @escaping (Result<Void, Error>) -> Void) {
        let friendRef = db.collection("users").document(userId).collection("friends").document(friend.uid)
        
        do {
            try friendRef.setData(from: friend) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(()))
            }
        } catch {
            completion(.failure(error))
        }
    }


    
}
