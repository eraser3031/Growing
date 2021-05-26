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
    @State var showQuestion = false
    @State var showChangeModelSheet = false
    @ObservedObject var placeSet: PlaceSetting
    @Namespace var namespace
    
    var cancel: () -> Void
    let bottomInset = UIApplication.shared.windows.filter{$0.isKeyWindow}.first?.safeAreaInsets.bottom ?? 0
    
    func binding(for item: Person) -> Binding<Person> {
        guard let index = girinVM.personList.firstIndex(where: { $0.id == item.id }) else {
            return .constant(Person())
        }
        return $girinVM.personList[index]
    }
    
    var body: some View {
        ZStack {
            ZStack{
                VStack {
                    HStack(alignment: .top){
                        
                        VStack(spacing: 18) {
                            //  MARK: - Question Small View
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(Color(.systemBackground))
                                .font(.system(size: 40))
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        showQuestion = true
                                    }
                                }
                            //  MARK: -
                            
                            //  MARK: - Change Model View
                            Image(systemName: "circle.fill")
                                .foregroundColor(Color(.systemBackground))
                                .font(.system(size: 40))
                                .overlay(
                                    Image(placeSet.selectModel.thumbnailName)
                                        .resizable()
                                        .scaledToFill()
                                        .clipShape(Circle())
                                        .padding(8)
                                )
                                .onTapGesture {
                                    showChangeModelSheet = true
                                }
                                .sheet(isPresented: $showChangeModelSheet){
                                    SelectModelView(selectModel: $placeSet.selectModel)
                                }
                            //  MARK: -
                        }
                        
                        
                        Spacer()
                        
                        //  MARK: - Cancel Buttton
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(.systemBackground))
                            .font(.system(size: 40))
                            .onTapGesture {
                                withAnimation(.timingCurve(0.16, 1, 0.3, 1, duration: 0.6)){
                                    start = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                    cancel()
                                }
                            }
                        //  MARK: -
                    }.padding(.horizontal, 20)
                    
                    Spacer()
                    
                    if placeSet.isPlaced == (true, true) {
                        VStack(spacing: 0){
                            
                            //  MARK: - Person Change Button
                            Picker(selection: $person,
                                   label:
                                    Text("\(person.name == "" ? "Select Kid".localized() : person.name)")
                                    .font(.system(size: 12, weight: .bold, design: .default))
                                    .foregroundColor(.primary)
                                    .minimumScaleFactor(1)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 2)
                                    .overlay(
                                        Capsule()
                                            .stroke(Color(.tertiaryLabel), lineWidth: 1)
                                    )
                            ) {
                                ForEach(girinVM.personList){ p in
                                    Text("\(p.name)").tag(p)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(.vertical, 10)
                            //  MARK: -
                            
                            HStack(spacing: 70) {
                                //  MARK: - Clear AR Environment Button
                                Button(action: {
                                    withAnimation(.spring()){
                                        let model = placeSet.arView!.wallEntity!.findEntity(named: "standard")
                                        placeSet.arView!.wallEntity!.removeChild(model!)
                                        placeSet.startSetting(placeSet.arView!)
                                    }
                                    //                                showClearAxisAlert = true
                                }) {
                                    VStack(spacing: 4) {
                                        Image(systemName: "move.3d")
                                            .font(.largeTitle)
                                            .foregroundColor(.girinYellow)
                                        Text("reset")
                                            .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 10)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                //                            .alert(isPresented: $showClearAxisAlert){
                                //                                Alert(title: Text("AR Axis Setting"), message: Text("Would you like to set up AR space again?"), primaryButton: .destructive(Text("Confirm"), action: {
                                //                                    withAnimation(.spring()){
                                //                                        let model = placeSet.arView!.wallEntity!.findEntity(named: "standard")
                                //                                        placeSet.arView!.wallEntity!.removeChild(model!)
                                //                                        placeSet.startSetting(placeSet.arView!)
                                //                                    }
                                //                                }), secondaryButton: .cancel())
                                //                            }
                                
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
                                        ReadyMeasureView(placeSet: placeSet, person: binding(for: person)) {
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
                            .padding(.vertical, 20)
                        }
                        .ignoresSafeArea()
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, bottomInset)
                        .background(Color(.systemBackground))
                        .transition(.move(edge: .bottom))
                    } else {
                        VStack(spacing: 2) {
                            Text("\(placeSet.isPlaced.floor ? "1" : "0") / 2")
                                .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 13)
                                .foregroundColor(.girinOrange)
                            
                            Text(placeSet.isPlaced.floor ? "Finding Wall".localized() : "Finding Floor".localized())
                                .scaledFont(name: CustomFont.Gilroy_Light.rawValue, size: 20)
                        }
                        .ignoresSafeArea()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color(.systemBackground)))
                        .padding(.vertical, 20)
                        .padding(.bottom, bottomInset)
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            
            if showQuestion {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showQuestion = false
                        }
                    }
                
                QuestionView(){
                    withAnimation(.spring()) {
                        showQuestion = false
                    }
                }
                .transition(.scale)
            }
            
            if !start {
                ZStack{
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    
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
                        
                        Text("Wait a second...".localized())
                            .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
                    }
                }
                
                .transition(.opacity)
                .zIndex(1)
            }
            
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

struct SelectModelView: View {
    @Binding var selectModel: Model
    @Environment(\.presentationMode) var presentationMode
    
    let gridItem: [GridItem] = [
        GridItem(.adaptive(minimum: 140, maximum: 140), spacing: 20, alignment: nil),
    ]
    
    func dismiss() -> Void {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        NavigationView {
            ScrollView{
                LazyVGrid(
                    columns: gridItem,
                    alignment: .center,
                    spacing: 20,
                    pinnedViews: [],
                    content: {
                        ForEach(Model.models){ model in
                            VStack(alignment: .leading) {
                                Button(action: {
                                    selectModel = model
                                    dismiss()
                                }) {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                                            .fill(Color(.secondarySystemBackground))
                                        
                                        Image(model.thumbnailName)
                                            .resizable()
                                            .scaledToFit()
                                            .padding()
                                        
                                    }.frame(height: 140)
                                }.buttonStyle(PlainButtonStyle())
                                
                                Text(model.displayName)
                                    .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
                            }
                        }
                    })
            }
            .navigationTitle(Text("Height Chart".localized()))
            .navigationViewStyle(StackNavigationViewStyle())
            .padding(.top, 28)
        }
    }
}

