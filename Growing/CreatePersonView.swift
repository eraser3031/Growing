//
//  CreatePersonView.swift
//  Growing
//
//  Created by Kimyaehoon on 30/03/2021.
//

import SwiftUI

struct CreatePersonView: View {
    @EnvironmentObject var girinVM: GirinViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State var person = Person()
    @State var start = false
    
    var confirm: () -> Void
    
    var body: some View {
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
                    Image(person.thumbnail)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)))
                        .clipShape(Circle())
                        .onTapGesture {
                            //이미지 피커 불러와서 person.thumbnail 데이터 넣어주기
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
        .edgesIgnoringSafeArea(.bottom)
    }
}
