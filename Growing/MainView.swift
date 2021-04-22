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
    @State var showARView = false
    @State var showNoPersonAlert = false
    @State var showSetting = false
    
    func binding(for item: Person) -> Binding<Person> {
        guard let index = girinVM.personList.firstIndex(where: { $0.id == item.id }) else {
            fatalError("no...")
        }
        return $girinVM.personList[index]
    }
    
    var body: some View {
        ZStack {
            ZStack{
                NavigationView{
                    VStack(spacing: 0){
                        Spacer()
                            .frame(height: 20)
                        
                        HStack(alignment: .top, spacing: 0){
                            VStack(alignment: .leading, spacing: 10){
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
                                
                                Text("Girin")
                                    .scaledFont(name: "Gilroy-ExtraBold", size: 34)
                                    .foregroundColor(Color.girinOrange)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "person.circle.fill")
                                .font(.system(size: 40))
                                .onTapGesture {
                                    showSetting = true
                                }
                                .sheet(isPresented: $showSetting){
                                    SettingView()
                                        .environmentObject(girinVM)
                                        .navigationViewStyle(StackNavigationViewStyle())

                                }
                        }.padding(.horizontal, 20)
                        
                        Spacer()
                            .frame(height: 10)
                        
                        ARViewButton()
                            .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
                        
                        Spacer()
                            .frame(height: 30)
                        
                        PersonListScrollView()
                        
                        Spacer()
                        
                    }
                    .navigationBarTitle("")
                    .navigationBarHidden(true)
                }.accentColor(.girinOrange)
            }
            //                .navigationViewStyle(StackNavigationViewStyle())
            
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
        VStack(spacing: 8){
            
            Image(systemName: "arkit")
                .font(.system(size: 40))
            
            Text("키 재러가기")
                .scaledFont(name: "SpoqaHanSansNeo-Bold", size: 17)
            
        }.frame(maxWidth: .infinity, maxHeight: 128)
        .background(
            Color.girinYellow
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .padding(.horizontal, 20)
        .contentShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onTapGesture {
            if girinVM.personList.count == 0 {
                showNoPersonAlert = true
            } else {
                showARView = true
            }
        }
        .alert(isPresented: $showNoPersonAlert){
            Alert(title: Text("데이터 없음"), message: Text("키를 재려면 등록한 아이가 한 명 이상 있어야 해요."),
                  dismissButton: .cancel())
        }
        .fullScreenCover(isPresented: $showARView){
            ContentView().environmentObject(girinVM)
        }
    }
    
    func PersonListScrollView() -> some View {
        
        func calScrollWidth(count: Int, height: CGFloat) -> CGFloat {
            CGFloat(count+2)*20+CGFloat(count+1)*height/1.4
        }
        
        return
            VStack(alignment: .leading, spacing: 0){
                Text("Kids")
                    .scaledFont(name: "Gilroy-ExtraBold", size: 28)
                    .padding(.horizontal, 20)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0){
                        ForEach(girinVM.personList) { person in
                            PersonCardView(person: person, editPerson: $showEditPerson)
                        }
                        
                        //                    PlusPersonCardView()
                    }
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
    @EnvironmentObject var girinVM: GirinViewModel
    @State var showRecordAlert = false
    @State var showEveryAlert = false
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Label("정보", systemImage: "info.circle.fill")) {
                    NavigationLink(destination: InfoView) {
                        Label("앱 정보", systemImage: "questionmark.circle.fill")
                    }
                }
                
                Section(header: Label("데이터", systemImage: "cylinder.split.1x2.fill")) {
                    Button(action: {
                        showRecordAlert = true
                    }) {
                        Label("일기 데이터 초기화", systemImage: "text.badge.xmark")
                    }.buttonStyle(PlainButtonStyle())
                    .alert(isPresented: $showRecordAlert) {
                        Alert(title: Text("일기 데이터 삭제"), message: Text("정말로 모든 일기 데이터를 삭제하시겠어요??"), primaryButton: .destructive(Text("확인"), action: {
                            for (index, _) in girinVM.personList.enumerated() {
                                girinVM.personList[index].records = []
                            }
                        }), secondaryButton: .cancel())
                    }
                    
                    Button(action: {
                        showEveryAlert = true
                    }) {
                        Label("모든 데이터 초기화", systemImage: "xmark.circle.fill")
                    }.buttonStyle(PlainButtonStyle())
                    .alert(isPresented: $showEveryAlert) {
                        Alert(title: Text("모든 데이터 삭제"), message: Text("정말로 모든 데이터를 삭제하시겠어요??"), primaryButton: .destructive(Text("확인"), action: {
                            girinVM.personList = []
                        }), secondaryButton: .cancel())
                    }
                }
            }.navigationTitle("설정")
            .accentColor(.girinOrange)
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

extension SettingView {
    var InfoView: some View {
        VStack(spacing: 0) {
            VStack(spacing: 0){
                Image("Icon")
                    .resizable()
                    .frame(width: 128, height: 128)
                    .cornerRadius(22)
                    .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
                    .padding(.bottom, 30)
                
                Text("Girin")
                    .font(.largeTitle).bold()
                    .padding(.bottom, 9)
                
                Text("Version: \(UIApplication.appVersion ?? "")")
                    .padding(.bottom, 30)
                
                Text("made by eraiser")
                    .foregroundColor(.gray)
                    .padding(.bottom, 4)
                Text("문의: eraser3031@gmail.com")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
}

struct PersonCardView : View {
    @EnvironmentObject var girinVM: GirinViewModel
    @State var showActionSheet = false
    var person: Person
    @Binding var editPerson: Person?
    @State var emptyPerson = Person()
    @State var alertRemove = false
    
    let width: CGFloat = screen.width/2+20
    var height: CGFloat {
        width * 1.4
    }
    
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
        VStack(spacing: 14) {
            NavigationLink(
                destination: PersonView(person: binding(for: person), editPerson: $editPerson).environmentObject(girinVM),
                label: {
                    if let image = person.thumbnail.toImage() {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: width, height: height)
                            .scaledToFill()
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
                    } else {
                        ZStack{
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .fill(Color.white)
                                .frame(width: width, height: height)
                                .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.18)), radius: 30, x: 0.0, y: 20)
                            
                            Image(systemName: "person.fill")
                                .foregroundColor(.second)
                                .font(.system(size: 60))
                        }
                    }
                }).buttonStyle(PlainButtonStyle())
            
            HStack(spacing: 0){
                VStack(alignment: .leading, spacing: 4){
                    Text(person.name)
                        .scaledFont(name: "SpoqaHanSansNeo-Bold", size: 20)
                    Text("\(Date().year - person.birthday.year)살 ")
                        .scaledFont(name: "SpoqaHanSansNeo-Regular", size: 15)
                }
                
                Spacer()
                
                Image(systemName: "ellipsis.circle.fill")
                    .font(.system(size: 28))
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
            }.frame(width: width)
        }.padding(.horizontal, 20)
        .padding(.bottom, 30)
        .padding(.top, 20)
    }
}
