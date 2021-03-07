////
////  ContentView.swift
////  Growing
////
////  Created by Kimyaehoon on 27/02/2021.
////
//
//import ARKit
//import SwiftUI
//import RealityKit
//import Combine
//import FocusEntity
//
//class PlacementSetting: ObservableObject {
//    @Published var placeAnchorPos = SIMD3<Float>(x: 0, y: 0, z: 0)
//    @Published var wallAnchorPos = SIMD3<Float>(x: 0, y: 0, z: 0)
//    @Published var cameraAnchorPos = SIMD3<Float>(x: 0, y: 0, z: 0)
//    var updateCancellable: Cancellable?
//}
//
//struct ContentView : View {
//    @State var isAR = false
//    var body: some View {
//        ZStack{
//            Text("hi!")
//                .onTapGesture {
//                    isAR.toggle()
//                }
//        }
//        .fullScreenCover(isPresented: $isAR) {
//            GrowMeasureView()
//        }
//        
//    }
//}
//
//struct GrowMeasureView: View {
//    @StateObject var placeSet = PlacementSetting()
//    @State var result: Float = 0
//    var body: some View {
//        ZStack{
//            ARViewContainer(placeSet: placeSet)
//                .edgesIgnoringSafeArea(.all)
//            
//            VStack{
//                Text("result: \(result)")
//            }
//        }.onTapGesture {
//            result = measureHeight(placeSet.placeAnchorPos.y, placeSet.cameraAnchorPos.y)
//        }
//    }
//    
//    private func measureHeight(_ a: Float, _ b: Float) -> Float {
//        abs(a - b) * 100 + 4 // cm + 오차범위
//    }
//}
//
//struct ARViewContainer: UIViewRepresentable {
//    @Environment(\.presentationMode) var presentationMode
//    @ObservedObject var placeSet: PlacementSetting
//    
//    func makeUIView(context: Context) -> CustomARView {
//        let arView = CustomARView(frame: .zero)
//        let cameraAnchor = AnchorEntity(.camera)
//        arView.scene.addAnchor(cameraAnchor)
//        placeSet.updateCancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
//            print(#fileID, #function, #line)
//            updateScene(arView: arView)
//        }
//        
//        return arView
//    }
//    
//    func updateUIView(_ uiView: CustomARView, context: Context) {}
//    
//    func updateScene(arView: CustomARView) {
//        
//        if arView.focusEntity!.onPlane {
//            // 이부분 수정 필요. 바로바로 값 넣어주는게 아니라 유저가 바닥을 확정지으면 넣어줘야 함.
//            placeSet.placeAnchorPos = arView.focusEntity?.anchor?.position ?? SIMD3(x: 0, y: 0, z: 0)
//            
//            placeSet.cameraAnchorPos = arView.cameraTransform.translation
//        }
//    }
//    
//}
//
//class CustomARView: ARView {
//
//    var focusEntity: FocusEntity?
//    
//    required init(frame: CGRect) {
//        super.init(frame: frame)
//        focusEntity = FocusEntity(on: self, style: .classic(color: UIColor(.blue)))
//        self.scene.addAnchor(focusEntity!)
//        configure(axis: .horizontal)
//    }
//    
//    @objc required dynamic init?(coder decoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    
//    private func configure(axis: ARWorldTrackingConfiguration.PlaneDetection) {
//        let config = ARWorldTrackingConfiguration()
//        config.planeDetection = [axis]
//        self.session.run(config)
//    }
//}
//
//#if DEBUG
//struct ContentView_Previews : PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//#endif
