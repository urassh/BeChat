//
//  LoginView.swift
//  BeChat
//
//  Created by saki on 2024/08/10.
//

import FirebaseAuth
import SwiftUI

struct LoginView: View {
    @State var repository: AuthProtocol = AuthImpl()
    @State var name = ""
    @Binding var homePath: [HomePath]

    var body: some View {
        VStack {
            Text("BeChat")
                .font(.custom("Shrikhand-Regular", size: 90))
                .padding()
            TextField("名前を入力", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()

            Button(
                action: {
                    Task {
                        try await repository.login(user: UnAuthenticatedUser(name: name))
                        homePath.append(.home)
                    }
                },
                label: {
                    Text("Login")
                        .padding()
                })
        }
        .onAppear {
            if Auth.auth().currentUser != nil {
                homePath.append(.home)
            }
        }
    }
}
