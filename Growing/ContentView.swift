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
import FocusEntity


class PlacementSetting: ObservableObject {
    @Published var placeAnchorPos: SIMD3<Float>?
    @Published var cameraAnchorPos = SIMD3<Float>(x: 0, y: 0, z: 0)
    @Published var result: Float = 0
    var updateCancellable: Cancellable?
    var tapListener: AnyCancellable?
    
    let tapSubject = PassthroughSubject<Bool, Never>()
}

struct ContentView : View {
    @StateObject var placeSet = PlacementSetting()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var girinVM: GirinViewModel
    
    var body: some View {
        ZStack{
            GrowMeasureView(placeSet: placeSet)
            
            CameraUiView(placeSet: placeSet){
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct GrowMeasureView: View {
    @ObservedObject var placeSet: PlacementSetting
    
    var body: some View {
        ZStack{
            ARViewContainer(placeSet: placeSet)
                .edgesIgnoringSafeArea(.all)
        }.onTapGesture {
//            result = measureHeight(placeSet.placeAnchorPos.y, placeSet.cameraAnchorPos.y)
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var placeSet: PlacementSetting
    @State var emptyPos: SIMD3<Float>?
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
        let cameraAnchor = AnchorEntity(.camera)
        arView.scene.addAnchor(cameraAnchor)
        placeSet.updateCancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            updateScene(arView: arView)
        }
        
        placeSet.tapListener = placeSet.tapSubject.sink(receiveValue: { value in
            if arView.focusEntity!.onPlane || placeSet.placeAnchorPos != nil {
                tapScene(value)
            }
        })
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    func updateScene(arView: CustomARView) {
        placeSet.cameraAnchorPos = arView.cameraTransform.translation
        if arView.focusEntity!.onPlane {
            emptyPos = arView.focusEntity?.anchor?.position ?? SIMD3(x: 0, y: 0, z: 0)
        }
    }

    func tapScene(_ value: Bool) {
        if (value == true) {
            placeSet.placeAnchorPos = emptyPos
            emptyPos = nil
        } else {
            placeSet.result = measureHeight(placeSet.placeAnchorPos!.y, placeSet.cameraAnchorPos.y)
        }
    }
    
    func measureHeight(_ a: Float, _ b: Float) -> Float {
        abs(a - b) * 100 + 4 // cm + 오차범위
    }
}

class CustomARView: ARView {

    var focusEntity: FocusEntity?
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        focusEntity = FocusEntity(on: self, style: .classic(color: UIColor(.init(.displayP3, red: 1, green: 1, blue: 1, opacity: 0.2))))
        self.scene.addAnchor(focusEntity!)
        configure(axis: .horizontal)
        
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(axis: ARWorldTrackingConfiguration.PlaneDetection) {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [axis]
//            self.scene.removeAnchor(focusEntity!.anchor!)
        self.session.run(config)
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

