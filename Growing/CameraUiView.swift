//
//  CameraUiView.swift
//  Growing
//
//  Created by Kimyaehoon on 19/03/2021.
//

import SwiftUI
import Combine

struct NewCameraUIView: View {
    
    @EnvironmentObject var girinVM: GirinViewModel
    @State var person: Person = Person()
    @State var offset: CGFloat = 0
    @State var selectItemPoses: [CGFloat] = []
    @State var showMeasureReady = false
    @State var start = false
    @State var showClearAxisAlert = false
    @State var snapShot: UIImage?
    @State var showCaptureAnimation = false
    @State var showReadyMeasure = false
    @ObservedObject var placeSet: PlaceSetting
    
    var cancel: () -> Void
    let bottomInset = UIApplication.shared.windows.filter{$0.isKeyWindow}.first!.safeAreaInsets.bottom
    
    var body: some View {
        ZStack {
            VStack {
                ZStack {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .foregroundColor(Color(.systemBackground))
                    
                    //  MARK: - Cancel Buttton
                    HStack{
                        Spacer()
                        
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                            .font(.title2)
                        
                    }.padding(.horizontal, 20)
                    .onTapGesture {
                        withAnimation(.timingCurve(0.16, 1, 0.3, 1, duration: 0.6)){
                            start = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            cancel()
                        }
                    }
                    //  MARK: -
                    
                    //  MARK: - Person Change Button
                    Picker(selection: $person,
                           label: HStack(spacing: 4){
                            Text("\(person.name == "" ? "Select Kid" : person.name)")
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                                .minimumScaleFactor(1)
                            Image(systemName: "arrowtriangle.down.fill")
                                .font(.footnote)
                                .foregroundColor(.primary)
                           }
                    ) {
                        ForEach(girinVM.personList){ p in
                            Text("\(p.name)").tag(p)
                        }
                    }
                    
                    .pickerStyle(MenuPickerStyle())
                    //  MARK: - 
                }
                
                Spacer()
                
                ZStack {
                    Rectangle()
                        .frame(maxWidth: .infinity, maxHeight: placeSet.isPlaced == (true, true) ? 140+bottomInset : 200+bottomInset)
                        .foregroundColor(Color(.systemBackground))
                        .cornerRadius(placeSet.isPlaced == (true, true) ? 0 : 20)
                    
                    if placeSet.isPlaced == (true, true) {
                        HStack(spacing: 70) {
                            //  MARK: - Clear AR Environment Button
                            Button(action: {
                                showClearAxisAlert = true
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "move.3d")
                                        .font(.largeTitle)
                                        .foregroundColor(.girinYellow)
                                    Text("position")
                                        .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 10)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            .alert(isPresented: $showClearAxisAlert){
                                Alert(title: Text("AR Axis Setting"), message: Text("Would you like to set up AR space again?"), primaryButton: .destructive(Text("Confirm"), action: {
                                    withAnimation(.spring()){
                                        let model = placeSet.arView!.wallEntity!.findEntity(named: "standard")
                                        placeSet.arView!.wallEntity!.removeChild(model!)
                                        placeSet.startSetting(placeSet.arView!)
                                    }
                                }), secondaryButton: .cancel())
                            }
                            
                            //  MARK: -
                            
                            //  MARK: - Measure Button
                            Image(systemName: "ruler")
                                .font(.title)
                                .foregroundColor(.black)
                                .background(
                                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(.girinYellow)
                                )
                                .onTapGesture {
                                    showMeasureReady = true
//                                    let model = placeSet.arView!.wallEntity!.findEntity(named: "standard")
//                                    placeSet.arView!.wallEntity!.removeChild(model!)
//                                    placeSet.arView?.session.pause()
                                }
                                .fullScreenCover(isPresented: $showMeasureReady){
                                    ReadyMeasureView(placeSet: placeSet, person: $person) {
                                        showMeasureReady = false //
//                                        placeSet.startSetting(placeSet.arView!)
                                    }
                                    .environmentObject(girinVM)
                                }
                            //  MARK: -
                            
                            //  MARK: - Capture Button
                            Button(action: {
                                if showCaptureAnimation == false {
                                    placeSet.arView!.snapshot(saveToHDR: false){ image in
                                        snapShot = image
                                        UIImageWriteToSavedPhotosAlbum(snapShot!, nil, nil, nil)
                                    }
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        showCaptureAnimation = true
                                    }
                                }
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "circle")
                                        .font(Font.system(.largeTitle, design: .default).weight(.semibold))
                                    Text("Camera")
                                        .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 10)
                                }
                            }
                            .buttonStyle(PlainButtonStyle())
                            //  MARK: -
                        }
                    } else {
                        VStack(spacing: 8) {
                            
                            Image("AxisGuide")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 90)
                            Text("Move back and forth to the center point\nat the edge where the wall meets the floor.")
                                .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
            }
            
            if !start {
                ZStack{
                    Color(.systemBackground)
                    
                    VStack(spacing: 8) {
                        Circle()
                            .stroke(Color.second, lineWidth: 1)
                            .frame(width: 64, height: 64)
                            .background(
                                Image("Icon")
                                    .resizable()
                                    .frame(width: 64, height: 64)
                                    .scaledToFit()
                                    .clipShape(Circle())
                            )
                        
                        Text("Wait a second...")
                            .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
                    }
                }
                
                .transition(.opacity)
                .zIndex(1)
            }
            
            Text("\(placeSet.arView?.wallEntity == nil ? "f" : "t")")
            
            if showCaptureAnimation {
                Color.white.ignoresSafeArea()
                    .transition(.opacity)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                showCaptureAnimation = false
                            }
                        }
                    }
            }
            
        }.onAppear{
            
            person = girinVM.personList.first!
            withAnimation(.timingCurve(0.7, 0, 0.84, 0, duration: 0.6).delay(0.4)){
                start = true
            }
        }
        .ignoresSafeArea(edges: .bottom)
        
    }
}

//MARK: Components
//extension CameraUiView {
//    func PersonSelectBar() -> some View {
//        HStack(spacing: 34) {
//            ForEach(girinVM.personList.indexed(), id: \.element.id) { (index, p) in
//                Text(p.name)
//                    .fontWeight(.bold)
//                    .if(selectIndex == index){
//                        $0.foregroundColor(.pink)
//                    }
//
//                    .font(.subheadline)
//                    .overlay(
//                        GeometryReader { geo in
//                            Color.clear
//                                .onChange(of: selectIndex){ value in
//                                    if value == index {
//                                        offset += screen.width/2 - geo.frame(in: .global).midX
//                                    }
//                                }
//                        }
//                    )
//                    .onTapGesture {
//                        selectIndex = index
//                    }
//
//            }
//        }.frame(height: 30)
//        .animation(.spring())
//        .offset(x: offset, y: 0)
//    }
//}

//struct CameraUiView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraUiView()
//            .environmentObject(GirinViewModel())
//    }
//}
