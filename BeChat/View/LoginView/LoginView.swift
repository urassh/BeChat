//
//  LoginView.swift
//  BeChat
//
//  Created by saki on 2024/08/10.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State var repository : AuthProtocol = AuthImpl()
    @State var name = ""
    var body: some View {
        if Auth.auth().currentUser?.uid != nil{
            HomeView()
        }else{
            VStack{
                TextField("名前を入力", text: $name)
                
                Button(action: {
                    Task{
                        try await  repository.login(user: UnAuthenticatedUser(name: name))
                    }
                }, label: {
                    Text("Login")
                })
            }
        }
    }
}

#Preview {
    LoginView()
}
