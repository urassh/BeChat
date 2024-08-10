//
//  AuthImpl.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/08.
//

import FirebaseAuth
import FirebaseFirestore

class AuthImpl: AuthProtocol {
    private let db = Firestore.firestore()
    private let COLLECTION = "users"
    func login(user: UnAuthenticatedUser) async throws -> AuthenticatedUser {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print("Anonymous login failed: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                }
                else if let authResult = authResult {
                    let authenticatedUser = AuthenticatedUser(
                        uid: authResult.user.uid, name: user.name)
                    do {
                        try self.db.collection(self.COLLECTION).document(authResult.user.uid)
                            .setData(
                                from: authenticatedUser)
                    }
                    catch {
                        print("Error Writing Document: \(error)")
                    }

                    continuation.resume(returning: authenticatedUser)
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully")
        }
        catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    func getName(uid: String) async -> String {
        do {
            let documentReference = db.collection(COLLECTION).document(uid)
            let documentSnapshot = try await documentReference.getDocument()
            let data = documentSnapshot.data()

            return data?["name"] as! String
        }
        catch {
            print(error)
            return ""
        }
    }
}
