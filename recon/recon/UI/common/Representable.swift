//
//  Representable.swift
//  recon
//
//  Created by Dreamfora on 2023/04/14.
//

import ARKit
import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    
    @EnvironmentObject var viewModel: ViewModel
    
    func makeUIView(context: Context) -> ARView {
        return viewModel.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        updateCounter(uiView: uiView)
    }
    
    private func updateCounter(uiView: ARView) {
    }
}
