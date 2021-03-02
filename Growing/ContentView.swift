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
    var updateCancellable: Cancellable?
}

struct ContentView : View {
    @State var isAR = false
    var body: some View {
        ZStack{
            Text("hi!")
                .onTapGesture {
                    isAR.toggle()
                }
        }
        .fullScreenCover(isPresented: $isAR) {
            GrowMeasureView()
        }
        
    }
}

struct GrowMeasureView: View {
    @State var test = "none"
    @StateObject var placeSet = PlacementSetting()
    var body: some View {
        ZStack{
            ARViewContainer(test: $test, placeSet: placeSet).edgesIgnoringSafeArea(.all)
            
            VStack{
                Text(test)
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var test: String
    @ObservedObject var placeSet: PlacementSetting
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
        let cameraAnchor = AnchorEntity(.camera)
        arView.scene.addAnchor(cameraAnchor)
        placeSet.updateCancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            print(#fileID, #function, #line)
            updateScene(arView: arView)
        }
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    func updateScene(arView: CustomARView) {
        test = arView.focusEntity!.onPlane ? "\(String(describing: arView.focusEntity?.anchor?.position.y)) + \(String(describing: arView.cameraTransform.translation.y))" : "no"
        
    }
    
}

class CustomARView: ARView {

    var focusEntity: FocusEntity?
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        focusEntity = FocusEntity(on: self, style: .classic(color: UIColor(.blue)))
        self.scene.addAnchor(focusEntity!)
        configure()
    }
    
    @objc required dynamic init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
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
