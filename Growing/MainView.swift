//
//  MainView.swift
//  Growing
//
//  Created by Kimyaehoon on 07/03/2021.
//

import SwiftUI
import Combine

struct MainView: View {
    @EnvironmentObject var girinVM: GirinViewModel
    @State var showCreatePersonView = false
    @State var showEditPersonView = false
    @State var showEditPerson: Person? = nil
    @State var showARView = false
    @State var showNoPersonAlert = false
    @State var showSetting = false
    
    func binding(for item: Person) -> Binding<Person> {
        guard let index = girinVM.personList.firstIndex(where: { $0.id == item.id }) else {
            return .constant(Person())
        }
        return $girinVM.personList[index]
    }
    
    var body: some View {
        ZStack {
            ZStack{
                NavigationView{
                    VStack(spacing: 0){
                        if UIApplication.shared.windows.filter{$0.isKeyWindow}.first!.safeAreaInsets.top > 1 {
                            Spacer()
                                .frame(height: 20)
                        }
                        
                        Header
                        
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
            .scaleEffect(showEditPersonView || showCreatePersonView ? 0.95 : 1)
            //            .blur(radius: showEditPersonView ? 4 : 0)
            .overlay(showEditPersonView || showCreatePersonView ? Color(.separator).ignoresSafeArea() : nil)
            //                .navigationViewStyle(StackNavigationViewStyle())
            
            
            
            CreatePersonView(showCreatePersonView: $showCreatePersonView)
            
            NewEditPersonView(person: binding(for: showEditPerson ?? Person()), showEditPersonView: $showEditPersonView)
            
        }
    }
}

struct FlipModifier: AnimatableModifier {
    @Namespace private var shapeTransition
    var progress: Double
    
    var animatableData: Double {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            if progress >= 0.5 {
                content
                    .rotation3DEffect(
                        .degrees(-180),
                        axis: (x: 0.0, y: 1.0, z: 0.0),
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 0.5)
            } else {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.main)
                    .frame(maxWidth: 300, maxHeight: 400)
                    .padding(20)
            }
        }
        .rotation3DEffect(
            .degrees(progress * -180),
            axis: (x: 0.0, y: 1.0, z: 0.0),
            anchor: .center,
            anchorZ: 0.0,
            perspective: 0.5)
    }
}


//MARK: Components
extension MainView {
    
    var Header: some View {
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
    }
    
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
                    HStack(alignment: .top, spacing: 0){
                        if girinVM.personList.count == 0 {
                            EmptyView()
                        } else {
                            ForEach(girinVM.personList) { person in
                                PersonCardView(person: person, editPerson: $showEditPerson, showEditPersonView: $showEditPersonView)
                            }
                        }
                        
                        PlusPersonCardView()
                            
                    }
                    .padding(.leading, 7)
                }
            }
        
    }
    
    func PlusPersonCardView() -> some View {
        
        let width: CGFloat = screen.width/2+20
        var height: CGFloat {
            width * 1.4
        }
        
        return ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .clipped()
                .foregroundColor(Color(.systemBackground))
            VStack(spacing: 2) {
                Image(systemName: "person.fill.badge.plus")
                    .font(.system(size: 50, weight: .regular, design: .default))
                    .foregroundColor(Color(.displayP3, red: 244/255, green: 144/255, blue: 12/255))
                Text("Plus Kid")
                    .scaledFont(name: "Gilroy-ExtraBold", size: 13)
            }
        }
        .frame(width: width, height: height)
        .clipped()
        .onTapGesture {
            withAnimation(.spring()) {
                showCreatePersonView = true
            }
        }
        .shadow(color: Color(.displayP3, red: 92/255, green: 103/255, blue: 153/255).opacity(0.2), radius: 40, x: 0, y: 20)
        .padding(.horizontal, 14)
        .padding(.bottom, 30)
        .padding(.top, 20)
        
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
    @Binding var showEditPersonView: Bool
    @State var emptyPerson = Person()
    @State var alertRemove = false
    @State var showSheet = false
    
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
            
            if let image = person.thumbnail.toImage() {
                ZStack{
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                }
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .shadow(color: Color(#colorLiteral(red: 0.1333333333, green: 0.3098039216, blue: 0.662745098, alpha: 0.2)), radius: 40, x: 0.0, y: 20)
                .sheet(isPresented: $showSheet) {
                    NewPersonView(person: binding(for: person), editPerson: $editPerson).environmentObject(girinVM)
                }
                .onTapGesture { showSheet = true }
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
                .sheet(isPresented: $showSheet) {
                    NewPersonView(person: binding(for: person), editPerson: $editPerson).environmentObject(girinVM)
                }
                .onTapGesture { showSheet = true }
            }
            
            HStack(spacing: 0){
                VStack(alignment: .leading, spacing: 4){
                    Text(person.name)
                        .scaledFont(name: "Gilroy-ExtraBold", size: 20)
                    
                    HStack{
                        Text("\(person.birthday.toAge()) years")
                            .font(.subheadline).bold()
                        
                        Text("\(person.nowHeight, specifier: "%.1f")cm")
                            .font(.subheadline).bold()
                            .foregroundColor(.girinOrange)
                    }
                    
                    
                }
                
                Spacer()
                
                Image(systemName: "ellipsis.circle.fill")
                    .font(.system(size: 28))
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("\(person.name)"), message: nil,
                                    buttons: [
                                        .default(Text("수정")){
                                            editPerson = person
                                            withAnimation(.spring()) {
                                                showEditPersonView = true
                                            }
                                            
                                        },
                                        .default(Text("삭제")){alertRemove = true},
                                        .cancel(Text("취소"))
                                    ])
                    }
                    .onTapGesture { showActionSheet = true }
                    .alert(isPresented: $alertRemove) {
                        Alert(title: Text("정보 삭제"), message: Text("정말로 아이의 데이터를 삭제하시겠어요??"), primaryButton: .destructive(Text("확인"), action: {
                            remove()
                        }), secondaryButton: .cancel())
                    }
            }.frame(width: width)
        }.padding(.horizontal, 14)
        .padding(.bottom, 30)
        .padding(.top, 20)
    }
}
