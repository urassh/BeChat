//
//  AuthProtocol.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import Foundation

protocol AuthProtocol {
    func login(user: UnAuthenticatedUser) async throws -> AuthenticatedUser
    func logout()
    func getName(uid: String) async -> String
}
