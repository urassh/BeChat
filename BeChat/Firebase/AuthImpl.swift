//
//  AuthImpl.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/08.
//

import Foundation
import FirebaseAuth

class AuthImpl: AuthProtocol {
    func login(user: UnAuthenticatedUser) async -> AuthenticatedUser {
        return await withCheckedContinuation { continuation in
            Auth.auth().signInAnonymously { authResult, error in
                if let error = error {
                    print("Anonymous login failed: \(error.localizedDescription)")
                    continuation.resume(throwing: error as! Never)
                } else if let authResult = authResult {
                    let authenticatedUser = AuthenticatedUser(uid: authResult.user.uid, name: user.name)
                    continuation.resume(returning: authenticatedUser)
                }
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
