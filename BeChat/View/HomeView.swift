//
//  HomeView.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/10.
//

import FirebaseAuth
import SwiftUI
import FirebaseMessaging

struct HomeView: View {
    @State var isTapped = false
    @State var partner = ""
    @State var partnerName = ""
    @State private var repository: AuthProtocol = AuthImpl()
    @State private var messageRepository: MessageProtocol = MessageStore()
    @State var uid = Auth.auth().currentUser?.uid ?? ""
    @State private var chats = [Chat]()
    @State var names = [String: String]()
    @State var isFriend = false

//    init(){
//          let center = UNUserNotificationCenter.current()
//          center.requestAuthorization(options: .alert) { granted, error in
//              if granted {
//                  print("許可されました！")
//              }else{
//                  print("拒否されました...")
//              }
//          }
//      }
      
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
                        ForEach(chats) { chat in
                            let partnerId = chat.from_id == uid ? chat.to_id : chat.from_id
                            let partnerName = names[partnerId] ?? "Loading...！"
                            let imageUrl = chat.last_image

                            CardView(name: .constant(partnerName), imageURL: .constant(imageUrl))
                                .onTapGesture {
                                    if chat.from_id != uid {
                                        partner = chat.from_id
                                    }
                                    else {
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
                            ChatView(partner: $partner)
                        }
                    )
                    .sheet(
                        isPresented: $isFriend,
                        content: {
                            FriendView()
                        }
                    )

                    .onAppear {
                        Notification().sendNotificationRequest()

                        messageRepository.fetchChatAll(for: uid) { result in
                            switch result {
                            case .success(let messages):
                                DispatchQueue.main.async {
                                    self.chats = messages
                                    getNames()

                                }
                            case .failure(let error):
                                print("Error fetching messages: \(error)")
                            }
                        }

                    }
                    .toolbar {

                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: {
                                isFriend = true

                            }) {
                                Image(systemName: "person.fill.badge.plus")
                            }
                        }
                    }

            }

        }
    }
    private func getNames() {
        Task {
            do {
                var nameDict = [String: String]()
                for chat in chats {
                    let partnerId = chat.from_id == uid ? chat.to_id : chat.from_id
                    if nameDict[partnerId] == nil {
                        let name = await repository.getName(uid: partnerId)
                        nameDict[partnerId] = name
                        print("Fetched name: \(name) for partnerId: \(partnerId)")
                    }
                }

                // names への代入前にデバッグ情報を追加
                DispatchQueue.main.async {

                    names = nameDict
                }
            }

        }
    }

}

#Preview {
    HomeView()
}
