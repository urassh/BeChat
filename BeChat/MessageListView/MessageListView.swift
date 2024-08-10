//
//  MessageListView.swift
//  BeChat
//
//  Created by saki on 2024/08/05.
//

import SwiftUI

struct MessageListView: View {
  @State var messages = [String()]
  @State var isTapMessage = false
  var body: some View {
    NavigationView {
      VStack {

        MessageImageView(iconSize: .constant(50))
          .frame(width: 270, height: 480)
          .aspectRatio(contentMode: .fit)
          .navigationTitle("BeChat")
          .padding(10)
          .onTapGesture {
            isTapMessage = true
          }
        ScrollView(.horizontal) {
          HStack {
            ForEach(messages, id: \.self) { name in
              MessageImageView(iconSize: .constant(30.0))
                .aspectRatio(contentMode: .fit)
            }
          }
        }
        .sheet(
          isPresented: $isTapMessage,
          content: {
            ChatView()
          }
        )
        .padding(.horizontal, 30)

      }
    }

  }
}

#Preview {
  MessageListView()
}
