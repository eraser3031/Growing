//
//  QuestionVIew.swift
//  View
//
//  Created by Kimyaehoon on 25/05/2021.
//

import SwiftUI

struct QuestionView: View {
    @State var start = false
    @State var pageIndex = 1
    @Environment(\.colorScheme) var colorScheme
    var dismiss: () -> Void
    
    func setupAppearance() {
        if colorScheme == .dark {
            UIPageControl.appearance().currentPageIndicatorTintColor = .white
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.2)
        } else {
            UIPageControl.appearance().currentPageIndicatorTintColor = .black
            UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        }
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                TabView(selection: $pageIndex) {
                    PageOne(start: $start).tag(1)
                    PageTwo().tag(2)
                    PageThree().tag(3)
                    PageFour().tag(3)
                }.tabViewStyle(PageTabViewStyle())
                .padding(.horizontal, 32)
                .padding(.top, 32)
                
                if pageIndex == 4 {
                    Button(action: {dismiss()}) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color.primary)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                            
                            Text("OK".localized())
                                .bold()
                                .foregroundColor(Color(.systemBackground))
                        }
                    }.buttonStyle(PlainButtonStyle())
                    .padding()
                }
            }
            .frame(width: 300, height: 350)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            
        }.onAppear{
            setupAppearance()
        }
    }
}

struct PageOne: View {
    @Binding var start: Bool
    var body: some View {
        VStack(spacing: 32){
            Text("Move your phone looking around the edge where the floor meets the wall.".localized())
                .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
            
            PageOneShape(start: $start)
            
            Spacer()
        }
    }
}

struct PageTwo: View {
    var body: some View {
        VStack(spacing: 72){
            Text("It's hard to recognize if the surroundings are too bright or dark.".localized())
                .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
            
            
            HStack{
                Image(systemName: "moon.stars.fill")
                    .foregroundColor(Color(.systemPurple))
                Image(systemName: "sun.max.fill")
                    .foregroundColor(Color(.systemOrange))
                Image(systemName: "questionmark.circle")
            }.font(.system(size: 40))
            
            Spacer()
        }
    }
}

struct PageThree: View {
    var body: some View {
        VStack(spacing: 40){
            Text("The position becomes more accurate as the model moves even after it is displayed. Nevertheless, if the key chart is in an odd position, it is recommended to initialize it by pressing the button.".localized())
                .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
            
            Image(systemName: "move.3d")
                .font(.system(size: 40))
            
            Spacer()
        }.tag(3)
    }
}

struct PageFour: View {
    var body: some View {
        VStack(spacing: 40){
            Text("That's enough explanation. Now enjoy it!".localized())
                .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
            Image(systemName: "face.smiling.fill")
                .font(.system(size: 60))
                .background(Circle().fill(Color.black).padding())
                .foregroundColor(Color(.systemYellow))
            
            Spacer()
        }.tag(4)
    }
}

struct PageOneShape: View {
    
    @Binding var start: Bool
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(.systemBackground))
                    .frame(width: 120, height: 64)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)), radius: 3, x: 0.0, y: 1)
                    .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
                
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(.systemBackground))
                    .frame(width: 140, height: 64)
                    .rotation3DEffect(
                        .degrees(60),
                        axis: (x: 1, y: 0.0, z: 0.0)
                    )
                    .offset(y: -14)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.05)), radius: 3, x: 0.0, y: 1)
                    .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
            }
            
            Circle()
                .stroke(Color.yellow, style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [6]))
                .padding(4)
                .frame(width: 40, height: 40)
            
            
            Image(systemName: "iphone")
                .font(.largeTitle)
                .offset(x: start ? 55 : -55, y: 0)
                .rotation3DEffect(
                    .degrees(start ? -15 : 15),
                    axis: (x: 0.0, y: -1.0, z: 0.0),
                    anchor: .center,
                    anchorZ: -12,
                    perspective: /*@START_MENU_TOKEN@*/1.0/*@END_MENU_TOKEN@*/
                )
        }.onAppear{
            withAnimation(.easeInOut(duration: 2.4).repeatForever()) {
                start = true
            }
        }
    }
}
