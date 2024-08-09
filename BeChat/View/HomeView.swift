//
//  HomeView.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/10.
//

import SwiftUI

struct HomeView: View {
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
                    ForEach(0..<5) { _ in
                        CardView()
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
            }

            Spacer()

        }
    }
}

#Preview {
    HomeView()
}
