//
//  ChatView.swift
//  BeChat
//
//  Created by saki on 2024/08/09.
//

import FirebaseAuth
import SwiftUI

struct ChatView: View {
    @State var chat = ""
    @State var messages = [TextMessage]()
    @State var uid = ""

    var body: some View {
        VStack {
            Spacer(minLength: 30)

            ScrollView(.vertical) {
                ForEach(messages) { message in
                    HStack {
                        if uid == message.to_id {
                            Spacer()
                            TextView(
                                text: message.contents,
                                color: Color(red: 0.9, green: 0.9, blue: 0.97))

                        }

                        if uid != message.to_id {
                            TextView(
                                text: message.contents,
                                color: Color(red: 0.86, green: 0.86, blue: 0.86))
                            Spacer()
                        }

                    }

                }

            }

            .padding(.leading, 30)

            HStack {
                TextField("メッセージを送信", text: $chat)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button(action: {
                    //送信の処理を書く

                }) {
                    Image(systemName: "paperplane.fill")
                }
            }
            .padding()

            .onAppear {

            }
        }

    }

}

#Preview {
    ChatView()
}

struct TextView: View {
    @State var text: String
    @State var color: Color
    var body: some View {
        Text(text)
            .padding(.horizontal, 20)
            .padding(.vertical, 7)
            .background(Color(color), in: RoundedRectangle(cornerRadius: 10))
            .padding(.vertical, 5)
            .padding(.trailing, 20)
    }
}
