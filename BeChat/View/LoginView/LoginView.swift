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
    var body: some View {
        if Auth.auth().currentUser?.uid != nil {
            HomeView()
        }
        else {
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
                        }
                    },
                    label: {
                        Text("Login")
                            .padding()
                    })
            }
        }
    }
}

#Preview {
    LoginView()
}
