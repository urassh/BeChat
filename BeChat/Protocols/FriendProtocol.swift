//
//  FriendProtocol.swift
//  BeChat
//
//  Created by saki on 2024/08/11.
//

import Foundation
import FirebaseAuth

protocol FriendProtocol {
    func searchUser(by uid: String, completion: @escaping (Result<AppUser, Error>) -> Void)
    func addFriend(userId: String, friend: AppUser, completion: @escaping (Result<Void, Error>) -> Void) 
    func fetchFriends(for userId: String, completion: @escaping ([AppUser]) -> Void)
}
