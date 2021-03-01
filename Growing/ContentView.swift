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

class En: ObservableObject {
    var cancellable: Cancellable?
}

struct ContentView : View {
    @EnvironmentObject var en: En
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
                .environmentObject(en)
        }
        
    }
}

struct GrowMeasureView: View {
    @EnvironmentObject var en: En
    @State var test = "none"
    var body: some View {
        ZStack{
            ARViewContainer(test: $test).edgesIgnoringSafeArea(.all)
                .environmentObject(en)
            
            GrowMeasureUIView(test: $test)
                .environmentObject(en)
            
        }
    }
}

struct GrowMeasureUIView: View {
    @EnvironmentObject var en: En
    @Binding var test: String
    var body: some View {
        VStack{
            Text(test)
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var en: En
    @Binding var test: String

    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
        
        en.cancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            updateScene(arView: arView)
        }
        
        let anchor = AnchorEntity()
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    func updateScene(arView: CustomARView) {
        print(#fileID, #function, #line)
        test = arView.focusEntity!.onPlane ? "yes" : "no"
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
