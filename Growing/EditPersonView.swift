//
//  EditPersonView.swift
//  Growing
//
//  Created by Kimyaehoon on 28/03/2021.
//

import SwiftUI
import Combine

struct NewEditPersonView: View {
    
    @EnvironmentObject var girinVM: GirinViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var person: Person
    @State var emptyPerson = Person()
    @State var start = false
    @State var keyboardOffset: CGFloat = 0
    
    @State var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var confirm: () -> Void
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        emptyPerson.thumbnail = inputImage.toString() ?? ""
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Edit")
                    .font(Font.system(.largeTitle, design: .default).weight(.bold))
                Spacer()
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(Color(.tertiaryLabel))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Picture")
                    .font(.headline)
                Image("myImage")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity, maxHeight: 120)
                    .clipped()
                    .overlay(ZStack {
                        Rectangle()
                            .foregroundColor(Color(.displayP3, red: 0/255, green: 0/255, blue: 0/255).opacity(0.4))
                        Image(systemName: "photo.fill.on.rectangle.fill")
                            .foregroundColor(Color(.systemBackground))
                            .font(.title2)
                    }
                    .cornerRadius(12), alignment: .center)
                    .cornerRadius(12)
                    .onTapGesture {
                        showImagePicker = true
                    }
                    .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                        ImagePicker(image: self.$inputImage)
                    }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Name")
                    .font(.headline)
                TextField("\(person.name)", text: $emptyPerson.name)
                    .padding()
                    .frame(height: 45)
                    .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)))
                    .cornerRadius(12)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Birthday")
                    .font(.headline)
                DatePicker("Date", selection: $emptyPerson.birthday, displayedComponents: .date).datePickerStyle(DefaultDatePickerStyle())
                    .accentColor(.orange)
                    .padding(8)
                    .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)))
                    .cornerRadius(12)
            }
            Spacer()
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .clipped()
                .foregroundColor(Color(.displayP3, red: 255/255, green: 202/255, blue: 71/255))
                .overlay(Text("Submit")
                    .bold()
                    .font(.body), alignment: .center)
                .onTapGesture {
                    person = emptyPerson
                    confirm()
                }
        }
        .padding(22)
        .frame(maxWidth: 375, maxHeight: 480)
        .clipped()
        .background(RoundedRectangle(cornerRadius: 20, style: .continuous)
            .foregroundColor(Color(.systemBackground)), alignment: .center)
        .shadow(color: Color(.displayP3, red: 92/255, green: 103/255, blue: 153/255).opacity(0.2), radius: 40, x: 0, y: 20)
        .padding(.horizontal, 30)
        .onReceive(Publishers.keyboardHeight){ height in
            if horizontalSizeClass == .compact {
                keyboardOffset = height
            }
        }
        .offset(x: 0, y: -keyboardOffset)
        .onAppear{
            emptyPerson.birthday = person.birthday
        }
    }
}


struct EditPersonView: View {
    @EnvironmentObject var girinVM: GirinViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var person: Person
    @State var emptyPerson = Person()
    @State var start = false
    @State var keyboardOffset: CGFloat = 0
    
    @State var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var confirm: () -> Void
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        emptyPerson.thumbnail = inputImage.toString() ?? ""
    }
    
    var body: some View {
        ZStack {
            
            Color.black.opacity(start ? 0.3 : 0)
                .onTapGesture {
                    confirm()
                }
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                 
                Spacer()
                    .frame(height: start ? horizontalSizeClass == .compact ? nil : 0 : screen.height)
                    .onAppear{start = true}
                    .animation(.spring())
                
                VStack(spacing: 20) {
                    
                    HStack {
                        Text("정보 수정").bold()
                            .font(.title)
                        
                        Spacer()
                    }.padding(.vertical, 28)
                    
                    VStack {
                        Image(uiImage: emptyPerson.thumbnail.toImage() ?? UIImage())
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .background(
                                ZStack {
                                    Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1))
                                    
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.gray)
                                        .font(.title3)
                                }
                            )
                            .clipShape(Circle())
                            .onTapGesture {
                                showImagePicker = true
                            }
                            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                                ImagePicker(image: self.$inputImage)
                            }
                        
                        Text("대표사진").bold()
                            .font(.subheadline)
                    }
                    
                    VStack(alignment: .leading){
                        Text("이름").bold()
                            .font(.subheadline)
                        
                        TextField("\(person.name)", text: $emptyPerson.name)
                            .padding()
                            .frame(height: 45)
                            .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)))
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading){
                        Text("생년월일").bold()
                            .font(.subheadline)
                        
                        HStack(spacing: 0) {
                            Text("\(emptyPerson.birthday.year)년 \(emptyPerson.birthday.month)월 \(emptyPerson.birthday.day)일")
                            
                            Spacer()
                            
                            DatePicker("", selection: $emptyPerson.birthday, displayedComponents: .date)
                        }.padding()
                        .frame(height: 45)
                        .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)))
                        .cornerRadius(12)
                    }
                    .padding(.bottom, 40)
                    
                    Text("확인").bold()
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.pink)
                        .cornerRadius(12)
                        .padding(.bottom, UIApplication.shared.windows.filter{$0.isKeyWindow}.first!.safeAreaInsets.bottom)
                        .onTapGesture {
                            person = emptyPerson
                            confirm()
                        }
                }
                .if(horizontalSizeClass == .regular){ body in
                    body
                        .frame(width: 375)
                }
                .padding(.horizontal, 20)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .animation(.spring())
            }
            .onReceive(Publishers.keyboardHeight){ height in
                if horizontalSizeClass == .compact {
                    keyboardOffset = height
                }
            }
            .offset(x: 0, y: -keyboardOffset)
            .edgesIgnoringSafeArea(.bottom)
            .onAppear{
                emptyPerson.birthday = person.birthday
            }
        }
    }
}

//struct EditPersonView_Previews: PreviewProvider {
//    static var previews: some View {
//        ZStack {
//            ModalBackgroundView(value: .constant(true))
//            
//            VStack {
//                Spacer()
//                EditPersonView(person: .constant(Person.samplePerson.first!))
//                
//            }.edgesIgnoringSafeArea(.bottom)
//        }
//    }
//}

struct ModalBackgroundView: View {
    @Binding var value: Bool
    var cancel: () -> Void
    
    var body: some View {
        Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).edgesIgnoringSafeArea(.all)
            .onTapGesture {
                cancel()
            }
            .opacity(value ? 0.5 : 0)
            .animation(Animation.easeInOut)
    }
}

struct ModalBackgroundView2: View {
    @Binding var value: Person?
    var cancel: () -> Void
    
    var body: some View {
        Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).edgesIgnoringSafeArea(.all)
            .onTapGesture {
                cancel()
            }
            .opacity(value != nil ? 0.5 : 0)
            .animation(Animation.easeInOut)
    }
}
