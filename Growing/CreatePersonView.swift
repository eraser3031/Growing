//
//  CreatePersonView.swift
//  Growing
//
//  Created by Kimyaehoon on 30/03/2021.
//

import SwiftUI
import Combine

struct CreatePersonView: View {
    @EnvironmentObject var girinVM: GirinViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var person = Person()
    @State var start = false
    @State var keyboardOffset: CGFloat = 0
    
    @State var showImagePicker = false
    @State private var inputImage: UIImage?
    
    var confirm: () -> Void
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        person.thumbnail = inputImage.toString() ?? ""
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
                        Text("아이 추가").bold()
                            .font(.title)
                        
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)))
                                .frame(width: 34, height:34)
                            
                            Image(systemName: "xmark")
                                .foregroundColor(.black)
                                .font(.title3)
                        }
                        .onTapGesture {
                            confirm()
                        }
                        
                    }.padding(.vertical, 28)
                    
                    VStack {
                        Image(uiImage: person.thumbnail.toImage() ?? UIImage())
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
                        
                        TextField("예빈이", text: $person.name)
                            .padding()
                            .frame(height: 45)
                            .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)))
                            .cornerRadius(12)
                    }
                    
                    VStack(alignment: .leading){
                        Text("생년월일").bold()
                            .font(.subheadline)
                        
                        HStack(spacing: 0) {
                            Text("\(person.birthday.year)년 \(person.birthday.month)월 \(person.birthday.day)일")
                            
                            Spacer()
                            
                            DatePicker("", selection: $person.birthday, displayedComponents: .date)
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
                            withAnimation(.spring()){
                                girinVM.personList.append(person)
                                confirm()
                            }
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
        }
    }
}
