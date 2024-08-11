//
//  HomeView.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/10.
//

import FirebaseAuth
import SwiftUI
import FirebaseMessaging
import UIKit

struct HomeView: View {
    @Binding var homePath: [HomePath]

    @State var isTapped = false
    @State var isFriend = false
    @State var partnerUID = ""
    @State var partnerName = ""
    @State private var repository: AuthProtocol = AuthImpl()
    @State private var messageRepository: MessageProtocol = MessageStore()
    @State private var chats = [Chat]()
    @State var names = [String: String]()
    @State var isFriend = false
    @State var friendsList = [AppUser]()
    @State var randomFriend = AppUser(uid: "", name: "")
    @State private var friendRepository: FriendProtocol = FriendStore()
      
    @State var lastImageUrl: String = ""

    var body: some View {
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
                        let uid = Auth.auth().currentUser!.uid
                        let partner_id = chat.from_id
                        let partner_name = names[partner_id] ?? "Loading...！"

                        CardView(name: partnerName, imageURL: lastImageUrl)
                            .onTapGesture {
                                partnerUID = chat.from_id
                                partnerName = partner_name
                                
                                print("partnerId : ", partnerUID)
                                isTapped = true
                            }
                    }
                    .padding()
                }
            }

                NavigationLink(destination: DrawView(partner: randomFriend)) {
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
                        
                        friendRepository.fetchFriends(for: uid){ result in
                         
                       
                                friendsList = result
                            randomFriend = friendsList.randomElement() ?? AppUser(uid: "", name: "")
                           
                            
                        }
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

=======
            NavigationLink(destination: DrawView(homePath: $homePath)) {
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
        }
        .onAppear {
            if Auth.auth().currentUser == nil, Auth.auth().currentUser!.uid.isEmpty {
                homePath.removeLast(homePath.count)
                return
            }

            let uid = Auth.auth().currentUser!.uid

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
        .sheet(isPresented: $isTapped) {
            let uid = Auth.auth().currentUser!.uid
            
            ChatView(homePath: $homePath, partner_uid: $partnerUID, partner_name: $partnerName, my_uid: uid)
        }
        .sheet(isPresented: $isFriend) {
            FriendView()
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

    private func getNames() {
        Task {
            do {
                var nameDict = [String: String]()
                for chat in chats {
                    let uid = Auth.auth().currentUser!.uid
                    let partnerId = chat.from_id == uid ? chat.to_id : chat.from_id
                    
                    lastImageUrl = chat.last_image == "" ? lastImageUrl : chat.last_image
                    
                    print(chat.from_id, lastImageUrl)
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
