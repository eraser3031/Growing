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
                    LineView(180, spacing: 24)
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
    
    func LineView(_ count: Int, spacing: CGFloat) -> some View {
        VStack(alignment: .trailing, spacing: spacing){
            ForEach((0..<count)) { num in
                if num%2 == 0 {
                    MainLine(count-num, spacing: spacing)
                }
            }
        }
    }
    
    func MainLine(_ height: Int, spacing: CGFloat) -> some View {
        
        func calOverlayRecord(_ height: Int) -> [Record] {
            person.records.filter{abs(Float(height) - $0.height) <= 1}
        }
        
        return HStack(spacing: spacing) {
            Text("\(height)cm")
                .font(.footnote)
                .fontWeight(.semibold)
            
            Spacer()
            NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.pink)
                        .frame(width: 125, height: 35)
                    
                    Text("\(height+1)cm ~ \(height-1)cm")
                        .font(.footnote)
                        .bold()
                        .foregroundColor(.white)
                }
            }.opacity(calOverlayRecord(height).count == 0 ? 0 : 1)
        }
        .overlay(
            ZStack {
                // Main Line
                Rectangle()
                    .fill(Color.black)
                    .cornerRadius(120)
                    .frame(width: 32.44, height: 2.64)
                
                // Sub Line
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.black)
                        .cornerRadius(120)
                        .frame(width: 17.69, height: 2.64)
                        .offset(y: 24+2.64*2)
                    
                    Spacer()
                }.frame(width: 32.44, height: 2.64)
            }
            .offset(x: -screen.width/2+90)
        )
        .background(
            ZStack {
                // Overlay Line
                ForEach(calOverlayRecord(height)) { record in
                    OverlayLine()
                        .offset(x:49,
                                y: CGFloat(Float(height) - record.height) * (spacing+2.64*2))
                }
            }
        )
        
    }
    
    func OverlayLine() -> some View {
        Rectangle()
            .fill(Color.pink.opacity(1))
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
