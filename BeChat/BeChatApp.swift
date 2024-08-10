//
//  BeChatApp.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import FirebaseCore
import SwiftUI

@main
struct BeChatApp: App {
  init() {
    FirebaseApp.configure()
  }

  var body: some Scene {
    WindowGroup {
      MessageListView()
    }
  }
}
