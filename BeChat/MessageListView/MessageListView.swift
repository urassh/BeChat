//
//  MessageListView.swift
//  BeChat
//
//  Created by saki on 2024/08/05.
//

import SwiftUI

struct MessageListView: View {
  @State var messages = [String()]
  var body: some View {
    NavigationView {
      VStack {

        MessageView(iconSize: .constant(50))
          .frame(width: 270, height: 480)
          .aspectRatio(contentMode: .fit)
          .navigationTitle("BeChat")
          .padding(10)
        ScrollView(.horizontal) {
          HStack {
            ForEach(messages, id: \.self) { name in
              MessageView(iconSize: .constant(30.0))
                .aspectRatio(contentMode: .fit)
            }
          }
        }
        .padding(.horizontal, 30)

      }
    }

  }
}

#Preview {
  MessageListView()
}
