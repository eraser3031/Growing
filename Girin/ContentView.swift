//
//  ContentView.swift
//  Growing
//
//  Created by Kimyaehoon on 27/02/2021.
//

import ARKit
import SwiftUI
import RealityKit
import Combine

class PlaceSetting: ObservableObject {
    @Published var isPlaced: (floor:Bool, wall:Bool) = (false, false)
    
    var updateCancellable: Cancellable?
    var placeCancellable: AnyCancellable?
    var modelCancellable: AnyCancellable?
    var testCancellable: AnyCancellable?
    
    var arView: ARCustomView?

    @Published var measureHeight: Float = 0
    
    @Published var selectModel: Model = Model.giraffe
    
    func clear() {
        updateCancellable?.cancel()
        placeCancellable?.cancel()
        modelCancellable?.cancel()
        testCancellable?.cancel()
    }
    
    func startSetting(_ arView: ARCustomView) {
        if let floorEntity = arView.floorEntity {
            arView.scene.removeAnchor(floorEntity)
            arView.floorEntity = nil
        }
        if let wallEntity = arView.wallEntity {
            arView.scene.removeAnchor(wallEntity)
            arView.wallEntity = nil
        }
        
        let session = ARWorldTrackingConfiguration()
        session.environmentTexturing = .automatic
        session.planeDetection = [.horizontal, .vertical]
        session.frameSemantics.insert(.personSegmentation)
        arView.session.run(session, options: .removeExistingAnchors)
        makeFloorEntity(arView)
    }
    
    func makeFloorEntity(_ arView: ARCustomView) {
        arView.floorEntity = AnchorEntity(plane: .horizontal, classification: .floor, minimumBounds: SIMD2<Float>(0.1,0.1))
        arView.scene.addAnchor(arView.floorEntity!)
    }
    
    func makeWallEntity(_ arView: ARCustomView) {
        arView.wallEntity = AnchorEntity(plane: .vertical, minimumBounds: SIMD2<Float>(0.1,0.1))
        arView.scene.addAnchor(arView.wallEntity!)
    }
}

struct ContentView : View {
    @EnvironmentObject var girinVM: GirinViewModel
    @Environment(\.presentationMode) var presentationMode
    @StateObject var placeSet = PlaceSetting()
    @State var test = false
    var body: some View {
        ZStack{
            ARViewContainer(placeSet: placeSet)
                .ignoresSafeArea()
            
            NewCameraUIView(placeSet: placeSet) {
                placeSet.clear()
                presentationMode.wrappedValue.dismiss()
                
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @ObservedObject var placeSet: PlaceSetting
    
    func checkPlaced(_ entity: AnchorEntity?) -> Bool {
        guard let entity = entity else {
            return false
        }
        
        return entity.isAnchored
    }
    
    func updateTransform(_ arView: ARCustomView, name: String) {
        guard let model = arView.wallEntity?.findEntity(named: name) else {
            return
        }
        
        model.setPosition(SIMD3<Float>(x: arView.wallEntity!.position(relativeTo: nil).x,
                                       y: arView.floorEntity!.position(relativeTo: nil).y,
                                       z: arView.wallEntity!.position(relativeTo: nil).z)
                          , relativeTo: nil)
    }
    
    func loadModel(model: Model){
        placeSet.testCancellable = Entity.loadAsync(named: model.name)
            .sink(receiveCompletion: { completion in
            print ("completion: \(completion)")
        }, receiveValue: { model in
            print(model)
            model.name = "standard"
            placeSet.arView!.wallEntity!.addChild(model)
            placeSet.testCancellable?.cancel()
        })
    }
    
    func makeUIView(context: Context) -> ARView {
        //        , cameraMode: .ar, automaticallyConfigureSession: true)
        let arView = ARCustomView(frame: .zero)
        placeSet.arView = arView
        
        placeSet.startSetting(arView)
        
        
        //  MARK: - Measure Method
        func measure() -> Float {
            let camera = arView.cameraTransform.translation
            let floor = arView.floorEntity!.position(relativeTo: nil)
            return abs(camera.y - floor.y) * 100  // cm + 오차범위
        }
        
        placeSet.updateCancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            var emptyPlaced: (floor:Bool, wall:Bool) = (false, false)
            
            emptyPlaced.wall = checkPlaced(arView.wallEntity)
            emptyPlaced.floor = checkPlaced(arView.floorEntity)
            
            if placeSet.isPlaced != emptyPlaced {
                withAnimation(.spring()) {
                    placeSet.isPlaced = emptyPlaced
                }
            }
            
            if placeSet.isPlaced == (true, true) {
                updateTransform(arView, name: "standard")
                placeSet.measureHeight = measure()
            }
        }

        placeSet.placeCancellable = placeSet.$isPlaced
            .sink { (floor, wall) in
                if floor && !wall {
                    placeSet.makeWallEntity(arView)
                }
                
                if floor && wall {
                    loadModel(model: placeSet.selectModel)
                    updateTransform(placeSet.arView!, name: "standard")
                }
                
            }
        
        placeSet.modelCancellable = placeSet.$selectModel
            .sink{ model in
                if placeSet.isPlaced == (true, true) {
                    let oldModel = placeSet.arView!.wallEntity!.findEntity(named: "standard")
                    if oldModel != nil {
                        placeSet.arView!.wallEntity!.removeChild(oldModel!)
                    }
                    loadModel(model: model)
                    updateTransform(placeSet.arView!, name: "standard")
                }
            }
        
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}

class ARCustomView: ARView {
    
    var floorEntity: AnchorEntity?
    var wallEntity: AnchorEntity?
    
    required init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
