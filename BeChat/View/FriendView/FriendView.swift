//
//  FriendView.swift
//  BeChat
//
//  Created by saki on 2024/08/11.
//

import SwiftUI
import FirebaseAuth

struct FriendView: View {
    @State private var uidToSearch = ""
    @State  var foundUser: AppUser?
    @State private var errorMessage: String?
    @State var repository: FriendProtocol = FriendStore()
    @State var uid = Auth.auth().currentUser?.uid ?? ""
    @State var friendsList = [AppUser]()
    var body: some View {
        NavigationView{
            VStack {
                
                HStack{
                    TextField("友達のIDを入力", text: $uidToSearch)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    Button(action: {
                        repository.searchUser(by: uidToSearch) { result in
                            switch result {
                            case .success(let user):
                                foundUser = user
                                errorMessage = nil
                            case .failure(let error):
                                foundUser = nil
                                errorMessage = error.localizedDescription
                            }
                        }
                        
                    }, label: {
                        Image(systemName: "magnifyingglass")
                    })
                    
                }
                if let user = foundUser {
                    HStack{
                        Text("\(user.name)")
                        Button(action: {
                            repository.addFriend(userId: Auth.auth().currentUser?.uid ?? "", friend: user) { result in
                                switch result {
                                case .success:
                                    print("追加しました！")
                                case .failure(let error):
                                    print("友達いません: \(error)")
                                }
                            }
                            
                        }, label:{
                            Image(systemName: "person.fill.badge.plus")
                        })
                    }
                    
                } else if let errorMessage = errorMessage {
                    Text("エラー: \(errorMessage)")
                        .foregroundColor(.red)
                }
                
                Text("あなたのIDは")
                Text(uid)
                    .textSelection(.enabled)
                    .padding(.bottom, 40)
                Text("友達一覧")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.title)
                List(friendsList, id: \.uid) { user in
                    Text(user.name)
                }
                
                
       
                .navigationTitle("友達を探す")
                .onAppear(){
                    repository.fetchFriends(for: uid) { friends in
                        DispatchQueue.main.async {
                            self.friendsList = friends
                            print(friendsList)
                        }
                        
                    }
                }
            }
            .padding(.horizontal,20)
            
        }    }
}

#Preview {
    FriendView(foundUser: AppUser(uid: "", name: ""))
}
