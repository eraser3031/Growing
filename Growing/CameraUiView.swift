//
//  CameraUiView.swift
//  Growing
//
//  Created by Kimyaehoon on 19/03/2021.
//

import SwiftUI
import Combine

struct CameraUiView: View {
    
    @EnvironmentObject var girinVM: GirinViewModel
    @State var person: Person?
    
    @State var selectIndex = 99
    @State var offset: CGFloat = 0
    @State var selectItemPoses: [CGFloat] = []
    @State var showMeasureReady = false
    
    @ObservedObject var placeSet: PlacementSetting
    
    var cancel: () -> Void
    
    var body: some View {
        let status = placeSet.status
        return ZStack {
            
//            VStack(spacing: 0) {
//                Spacer()
//                Rectangle()
//                    .fill(
//                        LinearGradient(gradient: isPlaced ?
//                        Gradient(colors: [Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))]) : Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 0)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))]),
//                                       startPoint: .top, endPoint: .bottom)
//                    )
//                    .frame(height: 220)
//            }.edgesIgnoringSafeArea(.all)
            
            VStack {
                HStack {
                    Spacer()
                    
                    ZStack() {
                        Circle()
                            .fill(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)))
                            .frame(width: 34, height:34)
                        
                        Image(systemName: "xmark")
                            .foregroundColor(.black)
                            .font(.title3)
                    }
                    .onTapGesture {
                        cancel()
                    }
                }.padding(.horizontal, 20)
                
                Spacer()
                
                PersonSelectBar()
                    .padding(.bottom, 20)
                
                ZStack(alignment: .center) {
                    HStack(spacing: 0) {
                        Image(systemName: "move.3d")
                            .foregroundColor(.white)
                            .font(.title)
                        
                        Spacer()
                        
                        Image("CameraButton")
                    }.padding(.horizontal, 30)
                    .padding(.bottom, 12)
                    
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(status == .measure ? Color.pink : .white)
                        .frame(width: 66, height: 66)
                        .overlay(
                            Image(systemName: status == .measure ? "ruler" : status == .wall ? "" : "")
                                .foregroundColor(status == .measure ? .white : .pink)
                                .font(.title)
                        )
                        .overlay(
                            Image(status == .measure ? "" : status == .wall ? "Wall" : "Place")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                        )
                        .opacity(placeSet.clickable ? 1 : 0.6)
                        .onTapGesture {
                            if placeSet.clickable {
                                placeSet.tapSubject.send(true)
                            }
                        }
                }
            }
            
            Text("\(placeSet.result)")
            
            //
            ZStack{
                Color.pink
                    .opacity(0.3)
                
                Text("s")
            }.contentShape(Rectangle())
            .onTapGesture {
                placeSet.tapSubject.send(false)
            }
            .opacity(showMeasureReady ? 1 : 0)
            .animation(.spring())
            
            VStack{
                Text("Now Height:\(placeSet.result)")
                Rectangle()
                    .fill(Color.girinYellow)
                    .frame(width: 150, height: 150)
                    .onTapGesture {
                        placeSet.status = .result
                    }
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.white)
            .opacity(status == .ready ? 1 : 0)
            
            VStack{
                Text("Result Height:\(placeSet.result)")
                Rectangle()
                    .fill(Color.girinYellow)
                    .frame(width: 150, height: 100)
                    .onTapGesture {
                        placeSet.status = .ready
                    }
                
                Rectangle()
                    .fill(Color.girinOrange)
                    .frame(width: 150, height: 100)
                    .onTapGesture {
                        placeSet.status = .measure
                    }
            }
            .edgesIgnoringSafeArea(.all)
            .background(Color.white)
            .opacity(status == .result ? 1 : 0)
        }
        .onAppear {
            selectIndex = 0
            person = girinVM.personList.first!
        }
    }
}

//MARK: Components
extension CameraUiView {
    func PersonSelectBar() -> some View {
        HStack(spacing: 34) {
            ForEach(girinVM.personList.indexed(), id: \.element.id) { (index, p) in
                Text(p.name)
                    .fontWeight(.bold)
                    .if(selectIndex == index){
                        $0.foregroundColor(.pink)
                    }
                    
                    .font(.subheadline)
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                                .onChange(of: selectIndex){ value in
                                    if value == index {
                                        offset += screen.width/2 - geo.frame(in: .global).midX
                                    }
                                }
                        }
                    )
                    .onTapGesture {
                        selectIndex = index
                    }
                    
            }
        }.frame(height: 30)
        .animation(.spring())
        .offset(x: offset, y: 0)
    }
}

//struct CameraUiView_Previews: PreviewProvider {
//    static var previews: some View {
//        CameraUiView()
//            .environmentObject(GirinViewModel())
//    }
//}
