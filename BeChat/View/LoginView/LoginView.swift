//
//  LoginView.swift
//  BeChat
//
//  Created by saki on 2024/08/10.
//

import FirebaseAuth
import SwiftUI
import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @State var repository: AuthProtocol = AuthImpl()
    @State var name = ""
    @Binding var homePath: [HomePath]

    var body: some View {
        VStack {
            Spacer()
            
            Text("BeChat")
                .font(.custom("Shrikhand-Regular", size: 80))
                .foregroundColor(.white)
                .padding()

            Spacer()

            TextField("名前を入力", text: $name)
                .textFieldStyle(.withBeChat)
                .foregroundStyle(.white)
            
            Button(
                action: {
                    Task {
                        try await repository.login(user: UnAuthenticatedUser(name: name))
                        homePath.append(.home)
                    }
                },
                label: {
                    Text("Login")
                        .fontWeight(.bold)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(.purple)
                        .clipShape(Capsule())
                })
                .padding()

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.pink, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
        .onAppear {
            if Auth.auth().currentUser != nil {
                homePath.append(.home)
            }
        }
    }
}

#Preview {
    LoginView(homePath: .constant([]))
}
