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

enum Status: String, Codable {
    case place
    case wall
    case measure
    case ready
    case result
}

class PlacementSetting: ObservableObject {
    @Published var placeAnchorPos: SIMD3<Float>?
    @Published var wallAnchorPos: SIMD3<Float>?
    @Published var cameraAnchorPos = SIMD3<Float>(x: 0, y: 0, z: 0)
    @Published var result: Float = 0
    @Published var status: Status = .place
    @Published var showDismissAlert = false
    
    @Published var clickable = false
    
    var updateCancellable: Cancellable?
    var tapCancellable: AnyCancellable?
    var statusCancellable: AnyCancellable?
    
    let tapSubject = PassthroughSubject<Bool, Never>()
}

struct ContentView : View {
    @StateObject var placeSet = PlacementSetting()
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var girinVM: GirinViewModel
    
    var body: some View {
        ZStack{
            ARViewContainer(placeSet: placeSet)
                .edgesIgnoringSafeArea(.all)
            
            CameraUiView(placeSet: placeSet){
                presentationMode.wrappedValue.dismiss()
            }
            
            VStack{
                Text("\(placeSet.status.rawValue)/\(placeSet.result)/\(placeSet.clickable ? "t" : "f")")
                    .font(.caption)
                    .foregroundColor(.girinOrange)
                Text("\(placeSet.placeAnchorPos?.y ?? 0)/\(placeSet.cameraAnchorPos.y)")
                    .font(.caption)
                    .foregroundColor(.girinOrange)
                Spacer()
            }
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var placeSet: PlacementSetting
    @State var emptyPos: SIMD3<Float>?
    
    func makeUIView(context: Context) -> CustomARView {
        let arView = CustomARView(frame: .zero)
        let cameraAnchor = AnchorEntity(.camera)
        
        let coachView = ARCoachingOverlayView(frame: CGRect(x: screen.width/2, y: screen.height/2, width: 0, height: 0))
        coachView.goal = .horizontalPlane
        coachView.session = arView.session
        coachView.activatesAutomatically = true
        
        arView.addSubview(coachView)
        arView.scene.addAnchor(cameraAnchor)
        arView.configure(axis: .horizontal)
        
        placeSet.updateCancellable = arView.scene.subscribe(to: SceneEvents.Update.self) { event in
            updateScene(arView: arView)
        }
        
        placeSet.tapCancellable = placeSet.tapSubject.sink(receiveValue: { value in
            switch placeSet.status {
            case .place:
                placeSet.placeAnchorPos = arView.focusEntity!.anchor!.position
                placeSet.status = .wall
            case .wall:
                placeSet.wallAnchorPos = arView.focusEntity!.position
                placeSet.status = .measure
            case .measure:
                placeSet.status = .ready
            default:
                print(#fileID, #function, #line)
            }
        })
        
        placeSet.statusCancellable = placeSet.$status.sink(receiveValue: { status in
            switch status {
            case .place:
                placeSet.placeAnchorPos = nil
                placeSet.wallAnchorPos = nil
                arView.configure(axis: .horizontal)
            case .wall:
                placeSet.wallAnchorPos = nil
                arView.configure(axis: .vertical)
            case .measure:
                print(#fileID, #function, #line)
            default:
                print(#fileID, #function, #line)
            }
        })
        
        return arView
    }
    
    func updateUIView(_ uiView: CustomARView, context: Context) {}
    
    func updateScene(arView: CustomARView) {
        placeSet.cameraAnchorPos = arView.cameraTransform.translation
        
        switch placeSet.status {
        case .place:
            if arView.focusEntity!.onPlane {
                placeSet.clickable = true
            } else {
                placeSet.clickable = false
            }
        case .wall:
            if arView.focusEntity!.onPlane {
                print(abs(placeSet.placeAnchorPos!.y - arView.focusEntity!.position.y))
                if abs(placeSet.placeAnchorPos!.y - arView.focusEntity!.position.y) > 0.4 {
                    placeSet.clickable = true
                } else {
                    placeSet.clickable = false
                }
            } else {
                placeSet.clickable = false
            }
        case .ready:
            placeSet.result = measureHeight(placeSet.placeAnchorPos!.y, placeSet.cameraAnchorPos.y)
        default:
            placeSet.clickable = true
        }
    }
    
    func buildExtensometer(arView: CustomARView){
//        let lineEntity =
    }
    
    func measureHeight(_ a: Float, _ b: Float) -> Float {
        abs(a - b) * 100 + 4 // cm + 오차범위
    }
}

class CustomARView: ARView {

    var focusEntity: FocusEntity?
    
    required init(frame: CGRect) {
        super.init(frame: frame)
        focusEntity = FocusEntity(on: self, style: .classic(color: UIColor(#colorLiteral(red: 1, green: 0.8, blue: 0.3019607843, alpha: 1))))
        self.scene.addAnchor(focusEntity!)
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
//
//먼저 뷰가 올라오면 FocusEntity가 바닥을 잡는다.(바닥 측정 상태)
//이후 바닥이 잡히면 벽을 잡는다.(벽 측정 상태)
//벽과 바닥이 확정되면 측정상태로 바뀐다.(키 측정 상태)
//    좌표 초기화 버튼을 통해 바닥 측정 상태로 돌아간다
//    혹은 특정 인물의 측정 버튼을 눌러 측정 준비 상태로 간다(측정 준비 상태)
//        측정 취소 버튼을 눌러 키 측정 상태로 돌아간다
//        화면을 클릭하여 측정을 완료 상태로 간다(측정 완료 상태)
//            재 측정을 통해 측정 준비 상태로 간다
//                측정이 완료되면 뷰를 업데이트 해서 보여준다.
//                    (태그를 통해 여러명의 키를 같이 보여줄 수 있음)
//
//측정된 키와 인물은 리스트뷰로 보여준다.
//인물 페이지로 가면 키의 그래프 변화와 나이대별 비교 및 성장에 대한 조언이 보여진다.

class LineEntity: Entity, HasAnchoring, HasModel {
    required init(color: UIColor) {
        super.init()
        self.components[ModelComponent] = ModelComponent(
            mesh: .generateBox(size: 0.1),
            materials: [SimpleMaterial(
                color: color,
                isMetallic: false)
            ]
        )
    }
    
    convenience init(color: UIColor, position: SIMD3<Float>) {
        self.init(color: color)
        self.position = position
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}
