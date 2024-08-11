//
//  ContentView.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import SwiftUI

enum HomePath: Int {
    case home, login

    @ViewBuilder
    func Destination(path: Binding<[Self]>) -> some View {
        switch self {
        case .home: HomeView(homePath: path)
        case .login: LoginView(homePath: path)
        }
    }
}

struct ContentView: View {
    @State var navigatePath: [HomePath] = []

    var body: some View {
        NavigationStack(path: $navigatePath) {
            LoginView(homePath: $navigatePath)
                .navigationDestination(for: HomePath.self) { appended in
                    appended.Destination(path: $navigatePath).navigationBarBackButtonHidden(true)
                }
        }
    }
}

#Preview {
    ContentView()
}
