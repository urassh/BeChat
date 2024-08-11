//
//  AppUser.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import Foundation

struct AppUser: Decodable, Encodable {

    let uid: String
    let name: String

}

struct AuthenticatedUser: Codable {
    let uid: String
    let name: String
}

struct UnAuthenticatedUser {
    let name: String
}
