//
//  EditPersonView.swift
//  Growing
//
//  Created by Kimyaehoon on 28/03/2021.
//

import SwiftUI

struct EditPersonView: View {
    @EnvironmentObject var givinVM: GirinViewModel
    @Binding var person: Person
    
    var body: some View {
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
                
            }.padding(.vertical, 28)
            
            VStack {
                Image(person.thumbnail)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 120, height: 120)
                    .background(Color(#colorLiteral(red: 0.9490196078, green: 0.9490196078, blue: 0.968627451, alpha: 1)))
                    .clipShape(Circle())
                
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
        }
        .padding(.horizontal, 20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct EditPersonView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ModalBackgroundView(value: .constant(true))
            
            VStack {
                Spacer()
                EditPersonView(person: .constant(Person.samplePerson.first!))
            }.edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ModalBackgroundView: View {
    @Binding var value: Bool
    var body: some View {
        Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)).opacity(0.5).edgesIgnoringSafeArea(.all)
            .onTapGesture {
                value = false
            }
            .animation(.spring())
            .opacity(value ? 1 : 0)
    }
}
