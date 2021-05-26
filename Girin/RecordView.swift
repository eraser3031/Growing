//
//  RecordView.swift
//  Growing
//
//  Created by Kimyaehoon on 18/03/2021.
//

import SwiftUI
import Combine

//struct RecordsView: View {
//    @EnvironmentObject var girinVM: GirinViewModel
//    @Binding var person: Person
//    var recordIndexs: [Int]
//    var title: () -> String
//    
//    func bindingIndex(index: Int) -> Binding<Record> {
//        return $person.records[index]
//    }
//    
//    func binding(record: Record) -> Binding<Record> {
//        guard let index = person.records.firstIndex(where: { $0.id == record.id }) else {
//            fatalError("Can't find scrum in array")
//        }
//        return $person.records[index]
//    }
//    
//    var body: some View {
//        List{
//            ForEach(person.records.indexed(), id: \.element.id) { (index, record) in
//                if recordIndexs.contains(index) {
//                    NavigationLink(destination:
//                        RecordView(person: $person, record: binding(record: record))
//                            .environmentObject(girinVM)
//                    ) {
//                        HStack(alignment: .top, spacing: 10){
////                            Image(person.thumbnail)
////                                .resizable()
////                                .frame(width: 100, height: 100)
////                                .scaledToFill()
////                                .cornerRadius(12)
//                            VStack(alignment: .leading, spacing: 2){
//                                Text(record.recordDate, style: .date)
//                                    .font(.title3)
//                                    .bold()
//                                
//                                // 소수점 2째까지 바꾸기
//                                Text("\(Int(record.height))cm")
//                                    .foregroundColor(.pink)
//                                    .font(.callout)
//                                
//                                Text(record.text)
//                                    .font(.callout)
//                                    .lineLimit(3)
//                            }
//                        }.padding(.vertical, 8)
//                    }
//                }
//            }
//            .onDelete(perform: { indexSet in
//                person.records.remove(at: indexSet.first!)
//            })
//        }
//        .navigationTitle("\(title())")
//        .navigationBarItems(trailing: EditButton())
//    }
//}

//struct RecordView: View {
//    @EnvironmentObject var girinVM: GirinViewModel
//    @Binding var person: Person
//    @Binding var record: Record
//    @State var showEndText = false
//    var body: some View {
//        VStack(spacing: 0) {
//
//            ScrollView(.horizontal, showsIndicators: false){
//                HStack{
//                    ForEach(record.pictures){ picture in
//                        Image(uiImage: UIImage(data: picture.data) ?? UIImage())
//                            .resizable()
//                            .frame(width: 80, height: 80)
//                            .cornerRadius(8)
//                    }
//                }
//            }
//
//            Divider()
//                .padding(20)
//
//            TextEditor(text: $record.text)
//                .padding(.horizontal, 20)
//
//            Spacer()
//
//        }.navigationTitle(record.title)
//        .navigationBarItems(trailing:
//            showEndText ?
//            Text("완료")
//                .foregroundColor(.pink)
//                .onTapGesture {
//                    hideKeyboard()
//                }
//            : nil
//        )
//        .onReceive(Publishers.keyboardHeight){ value in
//            if value != 0 {
//               showEndText = true
//            } else {
//                showEndText = false
//            }
//        }
//    }
//}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

//struct RecordView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordsView(person: .constant(Person.samplePerson.first!), recordIndexs: [1,2]){"123"}
//            .environmentObject(GirinViewModel())
//    }
//}


