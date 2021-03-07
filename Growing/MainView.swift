//
//  MainView.swift
//  Growing
//
//  Created by Kimyaehoon on 07/03/2021.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var girinVM: GirinViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                
                ARViewButton()
                
                PersonListScrollView()
                
            }.navigationTitle("둘러보기")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//MARK: Components
extension MainView {
    func ARViewButton() -> some View {
        VStack(spacing: 0){
            
            Image("ruler")
                .resizable()
                .scaledToFit()
                .padding(.top, 20)
            
            Spacer()
                .frame(height: 5)
            
            HStack(alignment: .bottom){
                Text("키 재러가기")
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                Image(systemName: "arkit")
                    .font(.system(size: 44))
            }.padding(20)
            .foregroundColor(.white)
            
        }.frame(maxWidth: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 1, green: 0.1764705882, blue: 0.3333333333, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.1764705882, blue: 0.4745098039, alpha: 1))]),
                           startPoint: .bottomLeading,
                           endPoint: .topTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 20)
    }
    
    func PersonListScrollView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack{
                ForEach(girinVM.personList) { person in
                    PersonCardView(person: person)
                }
            }
        }
    }
    
    func PersonCardView(person: Person) -> some View {
        VStack{
            Image()
            
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    Text(person.name)
                    HStack(spacing: 0) {
                        Text()
                        Text()
                    }
                    HStack(spacing: 0) {
                        Text("최근 기록일")
                        Text()
                    }
                }
                
                Spacer()
                
                ZStack{
                    
                }
            }
        }.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(GirinViewModel())
    }
}
