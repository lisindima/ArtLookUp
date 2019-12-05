//
//  PreviewView.swift
//  artlookup
//
//  Created by Дмитрий Лисин on 05.12.2019.
//  Copyright © 2019 Дмитрий Лисин. All rights reserved.
//

import SwiftUI
import Vision
import AVFoundation

struct PreviewView: UIViewControllerRepresentable {
    @Binding var objectName: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: VisionObjectRecognitionViewController, context: UIViewControllerRepresentableContext<PreviewView>) {
        // do something, like update the model if the name changes
    }
    
    func makeUIViewController(context: Context) -> VisionObjectRecognitionViewController {
        let vc = VisionObjectRecognitionViewController()
        vc.delegate = context.coordinator
        vc.view.translatesAutoresizingMaskIntoConstraints = true
        vc.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return vc
    }
    
    class Coordinator: NSObject, VisionObjectRecognitionViewControllerDelegate {
        
        var parent: PreviewView
        
        init(_ parent: PreviewView) {
            self.parent = parent
        }
        
        func mostLikelyObject(object: VNClassificationObservation?) {
            parent.$objectName.wrappedValue = object?.identifier ?? "none"
        }
    }
}

struct PreviewView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewView(objectName: .constant("blah"))
    }
}
