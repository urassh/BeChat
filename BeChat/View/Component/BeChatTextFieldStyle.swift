//
//  BeChatTextFieldStyle.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/11.
//

import Foundation
import SwiftUI

struct BeChatTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical, 20)
            .padding(.horizontal, 24)
            .background(Color.white.opacity(0.2), in: Capsule())
    }
}

extension TextFieldStyle where Self == BeChatTextFieldStyle {
    static var withBeChat: BeChatTextFieldStyle {
        .init()
    }
}
