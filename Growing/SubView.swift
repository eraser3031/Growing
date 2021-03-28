//
//  SubView.swift
//  Growing
//
//  Created by Kimyaehoon on 28/03/2021.
//

import SwiftUI

struct SubView: View {
    
    @Environment(\.presentationMode) var presentationMode
    var description: String
    var icon: String
    var cancelText: String
    var confirmText: String
    var completion: () -> Void
    
    var body: some View {
        ZStack {
            Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1)).edgesIgnoringSafeArea(.all)
            
            VStack{
                Image(systemName: icon)
                    .font(.largeTitle)
                    .padding(.vertical, 25)
                    .padding(.top, 25)
                
                Text(description)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .frame(width: 150)
                    .padding(.bottom, 50)
                
                HStack {
                    Button(action: {presentationMode.wrappedValue.dismiss()}) {
                        Text(cancelText).bold()
                    }.buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity).frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.secondary)
                    )
                    
                    Button(action: {completion()}) {
                        Text(confirmText).bold()
                            .foregroundColor(.white)
                    }.buttonStyle(PlainButtonStyle())
                    .frame(maxWidth: .infinity).frame(height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.pink)
                    )
                }
            }.padding()
            .frame(width: 335)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white)
            )
        }
        
    }
}

struct SubView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.white
            SubView(description: "지난 측정보다 +1cm 커졌어요!",
                    icon: "xmark",
                    cancelText: "돌아가기",
                    confirmText: "확인"){
                        print(#fileID, #function, #line)
            }
        }
    }
}
