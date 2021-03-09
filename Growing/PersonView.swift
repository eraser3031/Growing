//
//  PersonView.swift
//  Growing
//
//  Created by Kimyaehoon on 09/03/2021.
//

import SwiftUI

struct PersonView: View {
    @EnvironmentObject var girinVM: GirinViewModel
    @Binding var person: Person
    var body: some View {
        VStack(spacing: 0){
                ScrollView(.vertical) {
                    HStack {
                        LineView(150, spacing: 14)
                        
                        Spacer()
                    }.padding(.horizontal, 20)
                }
            }.navigationTitle("\(person.name)")
            .navigationBarTitleDisplayMode(.large)
            .navigationBarItems(trailing:
                                    Image(systemName: "ellipsis.circle.fill")
                                        .foregroundColor(.pink)
                                    .font(.title)
            )
            .navigationViewStyle(StackNavigationViewStyle())
    }
}

//MARK: Components
extension PersonView {
    func RecordView() -> some View {
        Text("130cm")
    }
    
    func LineView(_ count: Int, spacing: CGFloat) -> some View {
        VStack(alignment: .trailing, spacing: spacing){
            ForEach((0..<count)) { num in
                if num%2 == 0 {
                    MainLine(count-num, spacing: spacing)
                } else {
                    AssistLine()
                }
            }
        }
    }
    
    func MainLine(_ height: Int, spacing: CGFloat) -> some View {
        
        func calOverlayRecord(_ height: Int) -> [Record] {
            person.records.filter{Float(height) - $0.height <= 2 && Float(height) - $0.height > 0}
        }
        
        return HStack(spacing: spacing) {
            Text("\(height)cm")
                .font(.footnote)
                .fontWeight(.semibold)
            
            Rectangle()
                .fill(Color.black)
                .cornerRadius(120)
                .frame(width: 32.44, height: 2.64)
        }
        .overlay(
            ZStack {
                ForEach(calOverlayRecord(height)) { record in
                    OverlayLine()
                        .offset(x:49,
                            y: CGFloat(Float(height) - record.height) * (spacing*2-2.64*2))
                }
            }
        )
    }
    
    func AssistLine() -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.black)
                .cornerRadius(120)
                .frame(width: 17.7, height: 2.64)
            Spacer()
        }.frame(width: 32.44, height: 2.64)
    }
    
    func OverlayLine() -> some View {
        Rectangle()
            .fill(Color.pink.opacity(0.5))
            .cornerRadius(120)
            .frame(width: screen.width*2)
            .frame(height: 2.64)
    }
}

struct PersonView_Previews: PreviewProvider {
    static var previews: some View {
        PersonView(person: .constant(Person.samplePerson.first!))
    }
}
