//
//  MainView.swift
//  Growing
//
//  Created by Kimyaehoon on 07/03/2021.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var girinVM: GirinViewModel
    @State var showCreatePersonView = false
    @State var showEditPerson: Person? = nil
    
    func binding(for item: Person) -> Binding<Person> {
        guard let index = girinVM.personList.firstIndex(where: { $0.id == item.id }) else {
            fatalError("no...")
        }
        return $girinVM.personList[index]
    }
    
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
            
            if showCreatePersonView {
                CreatePersonView {showCreatePersonView = false}
            }
            
            if showEditPerson != nil {
                EditPersonView(person: binding(for: showEditPerson!)) {
                        showEditPerson = nil
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
                        PersonCardView(person: person, geo: geometry, editPerson: $showEditPerson)
                            .frame(maxHeight: geometry.frame(in: .global).height)
                            .frame(maxWidth: geometry.frame(in: .global).height/1.4)
                            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
                            .padding(.top, 15)
                            .padding(.bottom, 30)
                            .contentShape(RoundedRectangle(cornerRadius: 20))
                    }
                    
                    PlusPersonCardView()
                    
                    Spacer()
                }.frame(width: calScrollWidth(count: girinVM.personList.count,
                                              height: geometry.frame(in: .global).height),
                        height: geometry.frame(in: .global).height)
            }
        }
    }
    
    func PlusPersonCardView() -> some View {
        ZStack{
            Color.main 
            
            VStack(spacing: 26){
                Image("PersonPlus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 79, height: 72.5)
                
                Text("아이 추가").fontWeight(.semibold)
                    .font(.title3)
            }
            
        }.clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
        .padding(.top, 15)
        .padding(.bottom, 30)
        .contentShape(RoundedRectangle(cornerRadius: 20))
            .onTapGesture {
                showCreatePersonView = true
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

struct PersonCardView : View {
    @EnvironmentObject var girinVM: GirinViewModel
    @State var showActionSheet = false
    var person: Person
    var geo: GeometryProxy
    @Binding var editPerson: Person?
    @State var emptyPerson = Person()
    @State var alertRemove = false
    
    func binding(for item: Person) -> Binding<Person> {
        guard let index = girinVM.personList.firstIndex(where: { $0.id == item.id }) else {
            return $emptyPerson
        }
        return $girinVM.personList[index]
    }
    
    func remove() {
        withAnimation(.easeInOut){
            girinVM.personList.removeAll { p -> Bool in
                return p.id == person.id
            }
        }
    }
    
    var body: some View {
        NavigationLink(
            destination: PersonView(person: binding(for: person), editPerson: $editPerson).environmentObject(girinVM),
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
                        .actionSheet(isPresented: $showActionSheet) {
                            ActionSheet(title: Text("\(person.name)"), message: nil,
                                        buttons: [
                                            .default(Text("수정")){editPerson = person},
                                            .default(Text("삭제")){alertRemove = true},
                                            .cancel(Text("취소"))
                                        ])
                        }
                        .onTapGesture {
                            showActionSheet = true
                        }
                        .alert(isPresented: $alertRemove) {
                            Alert(title: Text("정보 삭제"), message: Text("정말로 아이의 데이터를 삭제하시겠어요??"), primaryButton: .destructive(Text("확인"), action: {
                                remove()
                            }), secondaryButton: .cancel())
                        }
                    }
                    .padding(20)
                    .background(Color.white)
                }.background(
                    ZStack {
                        Color.second
                        
                        Image(uiImage: person.thumbnail.toImage() ?? UIImage())
                            .resizable()
                            .scaledToFill()
                    }
                )
            }).buttonStyle(PlainButtonStyle())
    }
}
