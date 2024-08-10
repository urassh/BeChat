import SwiftUI
import FirebaseAuth
import FirebaseCore

struct ChatView: View {
    @State var chat = ""
    @State var messages = [TextMessage]()
    @State private var uid = Auth.auth().currentUser?.uid ?? ""
    @Binding var partner: String
    @State private var repository: MessageProtocol = MessageStore()
    
    var body: some View {
        VStack {
            Spacer(minLength: 30)
            
            ScrollView(.vertical) {
                ForEach(messages, id: \.id) { message in
                    HStack {
                        if uid == message.to_id {
                            Spacer()
                            TextView(
                                text: message.contents,
                                color: Color(red: 0.9, green: 0.9, blue: 0.97))
                        } else {
                            TextView(
                                text: message.contents,
                                color: Color(red: 0.86, green: 0.86, blue: 0.86))
                            Spacer()
                        }
                    }
                }
            }
            .padding(.leading, 30)
            
            HStack {
                TextField("メッセージを送信", text: $chat)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Button(action: {
                    guard !chat.isEmpty else { return }
                    
                    let message = TextMessage(
                        id: UUID(),
                        from_id: uid,
                        to_id: partner,
                        contents: chat,
                        timestamp: Timestamp()
                    )
                    
                    repository.send(with: message)
                    chat = ""
                }) {
                    Image(systemName: "paperplane.fill")
                }
            }
            .padding()
        }
        .padding()
        .onAppear {
            repository.fetchAll(for: partner) { result in
                switch result {
                case .success(let messages):
                    DispatchQueue.main.async {
                        self.messages = messages
                    }
                case .failure(let error):
                    print("Error fetching messages: \(error)")
                }
            }
        }
    }
}

#Preview {
    ChatView(partner: .constant(""))
}

struct TextView: View {
    @State var text: String
    @State var color: Color
    var body: some View {
        Text(text)
            .padding(.horizontal, 20)
            .padding(.vertical, 7)
            .background(Color(color), in: RoundedRectangle(cornerRadius: 10))
            .padding(.vertical, 5)
            .padding(.trailing, 20)
    }
}
