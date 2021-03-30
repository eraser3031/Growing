//
//  MainView.swift
//  Growing
//
//  Created by Kimyaehoon on 07/03/2021.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var girinVM: GirinViewModel
    @State var showEditPersonView = false
    
    var body: some View {
        ZStack {
            TabView{
                ZStack{
                    NavigationView{
                        VStack(spacing: 0){
                            
                            ARViewButton()
                            
                            Divider()
                                .padding(.horizontal, 20)
                                .padding(.top, 15)
                            
                            PersonListScrollView()
                            
                        }.navigationTitle("둘러보기")
                        .navigationBarTitleDisplayMode(.large)
                    }
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .tabItem {
                    Image(systemName: "ruler")
                    Text("측정")
                }
                
                SettingView()
                    .environmentObject(girinVM)
                    .navigationViewStyle(StackNavigationViewStyle())
                    .tabItem {
                        Image(systemName: "gear")
                        Text("설정")
                    }
            }.accentColor(.pink)
            
            ModalBackgroundView(value: $showEditPersonView){
                showEditPersonView = false
            }
            
            if showEditPersonView {
                CreatePersonView {
                    showEditPersonView = false
                } cancel: {
                    showEditPersonView = false
                }

            }
        }
        
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
        
        func calScrollWidth(count: Int, height: CGFloat) -> CGFloat {
            CGFloat(count+2)*20+CGFloat(count+1)*height/1.4
        }
        
        return GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20){
                    Spacer()
                        .frame(width: 0)
                    ForEach(girinVM.personList) { person in
                        PersonCardView(person: person, geo: geometry)
                            .frame(maxHeight: geometry.frame(in: .global).height)
                            .frame(maxWidth: geometry.frame(in: .global).height/1.4)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
                            .padding(.top, 15)
                            .padding(.bottom, 30)
                    }
                    
                    PlusPersonCardView()
                    
                    Spacer()
                }.frame(width: calScrollWidth(count: girinVM.personList.count,
                                              height: geometry.frame(in: .global).height),
                        height: geometry.frame(in: .global).height)
            }
        }
    }
    
    func PersonCardView(person: Person, geo: GeometryProxy) -> some View {
        
        func binding(for item: Person) -> Binding<Person> {
            guard let index = girinVM.personList.firstIndex(where: { $0.id == item.id }) else {
                fatalError("Can't find scrum in array")
            }
            return $girinVM.personList[index]
        }
        
        return NavigationLink(
            destination: PersonView(person: binding(for: person)).environmentObject(girinVM),
            label: {
                
                VStack(spacing: 0){
                    Spacer()
                    
                    HStack(alignment: .top){
                        VStack(alignment: .leading, spacing: 5){
                            Text(person.name)
                                .font(.title3)
                                .fontWeight(.semibold)
                            HStack(spacing: 0) {
                                Text("\(Date().year - person.birthday.year)살 ")
                                    .fontWeight(.medium)
                                Text("\(Int(person.nowHeight))cm")
                                    .bold()
                                    .foregroundColor(.pink)
                            }.font(.subheadline)
                            HStack(spacing: 0) {
                                Text("최근 기록일 ")
                                    .fontWeight(.medium)
                                Text(person.records.last?.recordDate ?? Date(), style: .date)
                                    .fontWeight(.semibold)
                                    .lineLimit(1)
                            }.font(.caption)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color(#colorLiteral(red: 1, green: 0.1764705882, blue: 0.4745098039, alpha: 1)))
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "ellipsis")
                                .font(.system(size: 26, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                }.background(
                    Image(person.thumbnail)
                        .resizable()
                        .scaledToFill()
                )
                
            }).buttonStyle(PlainButtonStyle())
    }
    
    func PlusPersonCardView() -> some View {
        Rectangle()
            .onTapGesture {
                showEditPersonView = true
            }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MainView().environmentObject(GirinViewModel())
        }
    }
}

struct SettingView: View {
    var body: some View {
        NavigationView{
            Form {
                Section(header: Label("정보", systemImage: "info.circle.fill")) {
                    NavigationLink(destination: Text("aa")) {
                        Label("앱 정보", systemImage: "questionmark.circle.fill")
                    }
                }
                
                Section(header: Label("데이터", systemImage: "cylinder.split.1x2.fill")) {
                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                        Label("일기 데이터 초기화", systemImage: "text.badge.xmark")
                    }.buttonStyle(PlainButtonStyle())
                    
                    Button(action: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/{}/*@END_MENU_TOKEN@*/) {
                        Label("모든 데이터 초기화", systemImage: "xmark.circle.fill")
                    }.buttonStyle(PlainButtonStyle())
                }
            }.navigationTitle("설정")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}
