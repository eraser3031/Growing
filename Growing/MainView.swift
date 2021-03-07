//
//  MainView.swift
//  Growing
//
//  Created by Kimyaehoon on 07/03/2021.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView{
            VStack{
                
            }.navigationTitle("둘러보기")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

//MARK: Components
extension MainView {
    func ARViewButton() -> some View {
        VStack{
            Spacer()
            HStack{
                Text("키 재러가기")
                    
            }
        }.frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
