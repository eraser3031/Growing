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
    var testCancellable: AnyCancellable?
    
    var arView: ARCustomView?
    
    @Published var info = ""
    @Published var info2 = ""
    
    func clear() {
        updateCancellable = nil
        placeCancellable = nil
        testCancellable = nil
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
        arView.session.run(session)
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
            
            NewCameraUIView(placeSet: placeSet) {
                presentationMode.wrappedValue.dismiss()
                placeSet.clear()
            }
            
            VStack {
                Text(placeSet.info)
                Text(placeSet.info2)
            }.font(.callout)
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
    
    func makeUIView(context: Context) -> ARView {
        //        , cameraMode: .ar, automaticallyConfigureSession: true)
        let arView = ARCustomView(frame: .zero)
        placeSet.arView = arView
        
        placeSet.startSetting(arView)
        
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
            }
        }

        placeSet.placeCancellable = placeSet.$isPlaced
            .sink { (floor, wall) in
                if floor && !wall {
                    placeSet.makeWallEntity(arView)
                }
                
                if floor && wall {
                    let loadRequest = Entity.loadAsync(named: "KeyChart1")
                    placeSet.testCancellable = loadRequest.sink(receiveCompletion: { completion in
                    }, receiveValue: { model in
                        model.name = "standard"
                        arView.wallEntity!.addChild(model)
                        updateTransform(arView, name: "standard")
                    })
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
