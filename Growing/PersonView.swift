//
//  PersonView.swift
//  Growing
//
//  Created by Kimyaehoon on 09/03/2021.
//

import SwiftUI

//struct PersonView: View {
//    @EnvironmentObject var girinVM: GirinViewModel
//    @Binding var person: Person
//    @Binding var editPerson: Person?
//    @State var showActionSheet = false
//    @State var alertRemove = false
//    func remove() {
//        person.records = []
//    }
//    
//    var body: some View {
//        ZStack {
//            VStack(spacing: 0){
//                ScrollView(.vertical) {
//                    HStack {
//                        LineView(180, spacing: 24)
//                    }.padding(.horizontal, 20)
//                }
//            }.navigationTitle("\(person.name)")
//            .navigationBarTitleDisplayMode(.large)
//            .navigationBarItems(trailing:
//                                    Image(systemName: "ellipsis.circle.fill")
//                                    .foregroundColor(.pink)
//                                    .font(.title)
//                                    .actionSheet(isPresented: $showActionSheet) {
//                                        ActionSheet(title: Text("\(person.name)"), message: nil,
//                                                    buttons: [
//                                                        .default(Text("수정")){editPerson = person},
//                                                        .default(Text("기록 초기화")){alertRemove = true},
//                                                        .cancel(Text("취소"))
//                                                    ])
//                                    }
//                                    .onTapGesture {
//                                        showActionSheet = true
//                                    }
//                                    .alert(isPresented: $alertRemove) {
//                                        Alert(title: Text("기록 삭제"), message: Text("정말 모든 기록을 삭제하시겠어요?"), primaryButton: .destructive(Text("확인"), action: {
//                                            remove()
//                                        }), secondaryButton: .cancel())
//                                    }
//
//            )
//            .navigationViewStyle(StackNavigationViewStyle())
//        }
//    }
//}

//MARK: Components
extension NewPersonView {
    
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
            let filterData = person.records.filter{abs(Float(height) - $0.height) <= 1}
            return filterData.sorted { first, second in
                first.recordDate.timeIntervalSince1970 < second.recordDate.timeIntervalSince1970
            }
        }
        
        func bindingRecordIndexs(records: [Record]) -> [Int] {
            var recordIndex: [Int] = []
            records.forEach { record in
                guard let index = person.records.firstIndex(where: { $0.id == record.id }) else {
                    return
                }
                recordIndex.append(index)
            }
            return recordIndex
        }
        
        let records = calOverlayRecord(height)
        let heightText = "\(height+1)cm ~ \(height-1)cm"
        
        return HStack(spacing: spacing) {
            Text("\(height)cm")
                .font(.footnote)
                .fontWeight(.semibold)
            
            Spacer()
            NavigationLink(destination: 
                            RecordsView(person: $person, recordIndexs: bindingRecordIndexs(records: records)){return heightText}
                    .environmentObject(girinVM)
            ){
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.pink)
                        .frame(width: 125, height: 35)
                    
                    Text(heightText)
                        .font(.footnote)
                        .bold()
                        .foregroundColor(.white)
                }
            }.opacity(records.count == 0 ? 0 : 1)
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
                ForEach(records) { record in
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

//struct PersonView_Previews: PreviewProvider {
//    static var previews: some View {
//        PersonView(person: .constant(Person.samplePerson.first!))
//    }
//}
