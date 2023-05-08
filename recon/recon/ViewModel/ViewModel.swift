//
//  ViewModel.swift
//  recon
//
//  Created by Dreamfora on 2023/04/14.
//

import SwiftUI
import RealityKit
import CoreData
import ARKit

final class ViewModel: ObservableObject {
    
    enum Action {
        case onTapCapture
        case onTapRotationX
        case onTapRotationY
        case onTapRotationZ
    }
    
    enum Direction {
        case x
        case y
        case z
    }
    
    var viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    
    @Published var arView: ARView!
    
    var model: ModelEntity?
    var boxAnchor: AnchorEntity?
    
    init() {
        arView = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.vertical, .horizontal]
        arView.session.run(config)
    }
    
    func action(_ action: Action) {
        switch action {
        case .onTapCapture:
            capture()
        case .onTapRotationX:
            rotation(.x)
        case .onTapRotationY:
            rotation(.y)
        case.onTapRotationZ:
            rotation(.z)
        }
    }
    
    private func capture() {
        arView.snapshot(saveToHDR: false) { [weak self] (image) in
            guard let self = self else { return }
            if let compressedImage = image?.pngData() {
                self.save(compressedImage)
            }
        }
    }
    
    private func save(_ imageData: Data) {
        let item = ARPhoto(context: viewContext)
        item.image = imageData
        item.createAt = Date()
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

// ar function
extension ViewModel {
    
    func addBox() {
        let query = arView.makeRaycastQuery(from: arView.center, allowing: .existingPlaneInfinite, alignment: .any)
        
        if let result = query {
            let sessionResult = arView.session.raycast(result)
            if let position = sessionResult.first?.worldTransform {
                let box: MeshResource = .generateBox(size: 0.1)
                let material = SimpleMaterial(color: .red, isMetallic: false)
                model = ModelEntity(mesh: box, materials: [material])
                boxAnchor = AnchorEntity(world: position)
                boxAnchor?.addChild(model!)
                arView.scene.anchors.append(boxAnchor!)
            }
        }
    }
    
    private func rotation(_ direction: Direction) {
        if let anchor = boxAnchor {
            let currentMatrix = model!.transform.matrix
            var transform = simd_float4x4()
            var rotation: simd_float4x4

            switch direction {
            case .x:
                rotation = simd_float4x4(SCNMatrix4MakeRotation(.pi, 1, 0, 0))
                transform = simd_mul(currentMatrix, rotation)
            case .y:
                rotation = simd_float4x4(SCNMatrix4MakeRotation(.pi, 0, 1, 0))
                transform = simd_mul(currentMatrix, rotation)
            case .z:
                rotation = simd_float4x4(SCNMatrix4MakeRotation(.pi, 0, 0, 1))
                transform = simd_mul(currentMatrix, rotation)
            }

            DispatchQueue.main.async {
                self.model!.move(to: transform, relativeTo: anchor, duration: 0.2)
            }
            
            transform = simd_mul(model!.transform.matrix, rotation)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.model!.move(to: transform, relativeTo: anchor, duration: 0.2)
            }
        }
    }
}
