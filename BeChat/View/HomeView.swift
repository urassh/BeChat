//
//  HomeView.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/10.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State var isTapped = false
    @State var partner = ""
    @State private var repository: AuthProtocol = AuthImpl()
    @State private var messageRepository: MessageProtocol = MessageStore()
    @State var uid = Auth.auth().currentUser?.uid ?? ""
    @State private var chats = [Chat]()
    var body: some View {
        NavigationView {
            VStack {
                Divider()
                
                Spacer()
                
                Text("今日のChatter")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                
                Text("さぁあなたも始めよう")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(chats) {chat in
                            CardView(name: .constant(chat.to_id))
                                .onTapGesture {
                                    if chat.from_id != uid {
                                        partner = chat.from_id
                                    } else {
                                        partner = chat.to_id
                                    }
                                    isTapped = true
                                }
                        }
                    }
                    .padding()
                }
                
                NavigationLink(destination: DrawView()) {
                    Image(systemName: "paperplane.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.cyan)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .padding(.top, 80)
                }
                
                Spacer()
                    .sheet(
                        isPresented: $isTapped,
                        content: {
                            ChatView( partner: $partner)
                        })
                
                    .onAppear {
                        messageRepository.fetchChatAll(for: uid) { result in
                            switch result {
                            case .success(let messages):
                                DispatchQueue.main.async {
                                    self.chats = messages
                                    print(chats)
                                }
                            case .failure(let error):
                                print("Error fetching messages: \(error)")
                            }
                        }
                    }
                
            }
        }
    }
}

#Preview {
    HomeView()
}
