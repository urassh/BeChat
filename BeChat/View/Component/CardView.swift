//
//  CardView.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/10.
//

import SwiftUI

struct CardView: View {
    @Binding var name: String
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
     
                VStack(alignment: .leading) {
                    Text(name)
                        .font(.headline)
                        .foregroundColor(.white)

                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 10)

            Spacer()
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 290)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.bottom, 10)
            Spacer()
        }
        .frame(width: 230, height: 370)
        .background(Color.mint)
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white, lineWidth: 2)
        )
        .shadow(radius: 5)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    CardView(name: .constant("saki"))
}
