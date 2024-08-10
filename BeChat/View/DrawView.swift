//
//  DrawView.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import FirebaseAuth
import PencilKit
import SwiftUI
import FirebaseCore

struct DrawView: View {
    @State private var penViewInstance = PenView()
    @State private var image: UIImage = UIImage(named: "sample")!
    
    @State private var repository: MessageProtocol = MessageStore()
    @State var uid = (Auth.auth().currentUser?.uid ?? "12345")
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        
        penViewInstance
            .toolbar {
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        penViewInstance.undo()
                    }) {
                        Image(systemName: "arrowshape.turn.up.backward.circle")
                    }
                }
                
                //送信
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        image = penViewInstance.saveImage()
                        let imageMessage = ImageMessage(
                            id: UUID(), from_id: "Jc92RwR8XLVPxU1N2GVtEPci2tu1", to_id: uid, image: image,timestamp: Timestamp())
                        
                        repository.send(with: imageMessage)
                        self.presentation.wrappedValue.dismiss()
                        
                    }) {
                        Image(systemName: "paperplane.fill")
                    }
                }
            }
    }
    
}

struct PenView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PKToolPickerObserver {
        var parent: PenView
        
        init(parent: PenView) {
            self.parent = parent
        }
        
    }
    
    typealias UIViewType = PKCanvasView
    let toolPicker = PKToolPicker()
    
    let pkcView = PKCanvasView()
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        pkcView.drawingPolicy = PKCanvasViewDrawingPolicy.anyInput
        toolPicker.addObserver(pkcView)
        toolPicker.setVisible(true, forFirstResponder: pkcView)
        
        pkcView.becomeFirstResponder()
        pkcView.isOpaque = false
        
        return pkcView
    }
    
    func undo() {
        if let undoManager = self.pkcView.undoManager {
            undoManager.undo()
        }
    }
    
    func saveImage() -> UIImage {
        
        let bounds = self.pkcView.bounds
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale)
        self.pkcView.drawing.image(from: bounds, scale: scale).draw(in: bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
    }
}
