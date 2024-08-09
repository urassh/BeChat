//
//  TodayMessageView.swift
//  BeChat
//
//  Created by saki on 2024/08/05.
//

import SwiftUI

struct MessageView: View {
  @Binding var iconSize: CGFloat
  var body: some View {

    VStack {

      VStack(alignment: .leading) {
        if iconSize >= 50.0 {

          HStack {
            Image("sample2")
              .resizable()
              .clipShape(Circle())
              .frame(width: iconSize, height: iconSize)
              .padding(.trailing, 10)
            Text("saki")
              .minimumScaleFactor(0.1)
              .lineLimit(1)

          }
        }

        Image("sample2")
          .resizable()
          .frame(maxWidth: 300, maxHeight: 500)

      }

    }

  }
}
#Preview {
  MessageView(iconSize: .constant(50.0))
}
