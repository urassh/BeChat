//
//  DrawView.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import SwiftUI
import PencilKit

struct DrawView: View {
    @State private var penViewInstance = PenView()
    @State private var image : UIImage = UIImage(named: "sample")!
    
    var body: some View {
        NavigationView{
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
                            image =  penViewInstance.saveImage()

                        }){
                            Image(systemName: "paperplane.fill")
                        }
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
    
    func undo(){
        if let undoManager = self.pkcView.undoManager {
            undoManager.undo()
        }
    }
    
    func saveImage() -> UIImage {
        let data  =  pkcView.drawing.dataRepresentation()
        return UIImage(data: data)!
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
    }
}
