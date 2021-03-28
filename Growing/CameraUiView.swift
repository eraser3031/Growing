//
//  CameraUiView.swift
//  Growing
//
//  Created by Kimyaehoon on 19/03/2021.
//

import SwiftUI

struct CameraUiView: View {
    
    @EnvironmentObject var girinVM: GirinViewModel
    @State var person: Person?
    
    @State var selectIndex = 99
    @State var offset: CGFloat = 0
    @State var selectItemPoses: [CGFloat] = []
    //checkmate
    var body: some View {
        ZStack {
            
            VStack(spacing: 0) {
                Spacer()
                Rectangle()
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5))]), startPoint: .top, endPoint: .bottom)
                    )
                    .frame(height: 220)
            }.edgesIgnoringSafeArea(.all)
            
            VStack {
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
                    
                    Image(systemName: "ruler")
                        .foregroundColor(.white)
                        .font(.title)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.pink)
                                .frame(width: 66, height: 66)
                        )
                }
            }
            
            Text("\(offset) \(selectIndex)")
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

struct CameraUiView_Previews: PreviewProvider {
    static var previews: some View {
        CameraUiView()
            .environmentObject(GirinViewModel())
    }
}
