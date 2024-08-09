//
//  ChatView.swift
//  BeChat
//
//  Created by saki on 2024/08/09.
//

import SwiftUI

struct ChatView: View {
    @State var chat = ""
    @State var messages = [String()]
    var body: some View {
        VStack(alignment: .leading){
            ScrollView(.vertical){
                ForEach(messages, id:  \.self){message in
                    Text(message)
                        .frame(width: Double.infinity,height: 30)
                        .padding(.horizontal,30)
                    
                        .background(Color.cyan, in: RoundedRectangle(cornerRadius: 10))
                        .padding(.vertical, 5)
                    
                    
                }
                
            }
            .padding(.horizontal, 30)
            
            HStack{
                TextField("メッセージを送信", text: $chat)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button(action: {
                    
                }){
                    Image(systemName: "paperplane.fill")
                }
            }
            .padding()
            
            .onAppear(){
                messages = ["りんご","バナナ"]
            }
        }
      
    }
    
}

#Preview {
    ChatView()
}
