//
//  CameraUiView.swift
//  Growing
//
//  Created by Kimyaehoon on 19/03/2021.
//

import SwiftUI

struct CameraUiView: View {
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
                HStack(spacing: 0) {
                    Image(systemName: "move.3d")
                        .foregroundColor(.white)
                        .font(.title)
                    Spacer()
                    Image(systemName: "ruler")
                        .foregroundColor(.white)
                        .font(.title)
                        .background(
                            RoundedRectangle(cornerRadius: 20, style: .continuous)
                                .fill(Color.pink)
                                .frame(width: 66, height: 66)
                        )
                    Spacer()
                    Image("CameraButton")
                }.padding(.horizontal, 30)
                .padding(.bottom, 12)
            }
        }
    }
}

//MARK: Components
extension CameraUiView {
    
}

struct CameraUiView_Previews: PreviewProvider {
    static var previews: some View {
        CameraUiView()
    }
}
