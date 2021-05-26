//
//  PersonView.swift
//  Growing
//
//  Created by Kimyaehoon on 09/03/2021.
//

import SwiftUI

struct NewPersonView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var girinVM: GirinViewModel
    @Binding var person: Person
    @Binding var editPerson: Person?
    @State var showActionSheet = false
    @State var alertRemove = false
    @State var start = false
    
    @State var seg = "Chart"
    
    @State var selfRecordHeight = ""
    
    func remove() {
        person.records = []
    }
    
    private func topH(_ height: Float) -> Int {
        Int(height) + 3
    }
    
    var body: some View {
        let topHeight = topH(person.bestHeight)
        
        return VStack(spacing: 0){
            Spacer()
                .frame(height: 34)
            
            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    
                    if let image = person.thumbnail.toImage() {
                        Circle()
                            .stroke(Color(.tertiarySystemGroupedBackground), lineWidth: 1)
                            .frame(width: 64, height: 64)
                            .background(
                                Image(uiImage: image)
                                    .resizable()
                                    .frame(width: 64, height: 64)
                                    .scaledToFill()
                                    .clipShape(Circle())
                            )
                            .padding(.bottom, 10)
                            .opacity(start ? 1 : 0)
                            .animation(.timingCurve(0.12, 0, 0.39, 0, duration: 0.25))
                    } else {
                        Circle()
                            .stroke(Color(.tertiarySystemGroupedBackground), lineWidth: 1)
                            .frame(width: 64, height: 64)
                            .background(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .foregroundColor(Color.second)
                                    .frame(width: 48, height: 48)
                                    .scaledToFit()
                                    .clipShape(Circle())
                            )
                            .padding(.bottom, 10)
                            .opacity(start ? 1 : 0)
                            .animation(.timingCurve(0.12, 0, 0.39, 0, duration: 0.25))
                    }
                    
                    
                    Text("\(person.name)")
                        .scaledFont(name: "Gilroy-ExtraBold", size: 20)
                        .padding(.bottom, 5)
                        .opacity(start ? 1 : 0)
                        .animation(.timingCurve(0.12, 0, 0.39, 0, duration: 0.25))
                    
                    Text("\(person.nowHeight, specifier: "%.2f")cm")
                        .scaledFont(name: "Gilroy-ExtraBold", size: 34)
                        .opacity(start ? 1 : 0)
                        .animation(.timingCurve(0.12, 0, 0.39, 0, duration: 0.3).delay(1.2))
                }
                
                Spacer()
                //
                Image(systemName: "ellipsis.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.primary)
                    .onTapGesture {
                        showActionSheet = true
                    }
                    .actionSheet(isPresented: $showActionSheet) {
                        ActionSheet(title: Text("\(person.name)"), message: nil,
                                    buttons: [
                                        .default(Text("수정")){
                                            presentationMode.wrappedValue.dismiss()
                                            editPerson = person
                                        },
                                        .default(Text("기록 초기화")){alertRemove = true},
                                        .cancel(Text("취소"))
                                    ])
                    }
                    .alert(isPresented: $alertRemove) {
                        Alert(title: Text("기록 삭제"), message: Text("정말 모든 기록을 삭제하시겠어요?"), primaryButton: .destructive(Text("확인"), action: {
                            remove()
                            girinVM.save() //
                        }), secondaryButton: .cancel())
                    }
                
            }.padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            Picker(selection: $seg, label: EmptyView()) {
                Text("Chart").scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17).tag("Chart")
                Text("Record").scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17).tag("Record")
            }.pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            if seg == "Chart" {
                if person.records.count != 0 {
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(1..<topHeight){ index in
                            HStack {
                                Text("\(topHeight-index)cm")
                                    .scaledFont(name: "Gilroy-ExtraBold", size: 12)
                                    .lineLimit(1)
                                    .frame(width: 48, alignment: .leading)
                                    .opacity(start ? 1 : 0)
                                    .animation(.timingCurve(0.87, 0, 0.13, 1, duration: 1).delay(Double(topHeight-index)/Double(person.bestHeight)*0.3))
                                makeLineView(index: topHeight-index)
                            }.id(topHeight-index)
                        }
                    }.padding(.horizontal, 20)
                } else {
                    VStack {
                        Spacer()
                        Text("There's no record yet.")
                            .scaledFont(name: "Gilroy-ExtraBold", size: 17)
                            .foregroundColor(Color(.tertiaryLabel))
                        Spacer()
                    }
                }
            } else {
                if person.records.count != 0 {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            ForEach(person.records.reversed()) { record in
                                RecordCellView(person: $person, record: record)
                                    .environmentObject(girinVM)
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("There's no record yet.")
                            .scaledFont(name: "Gilroy-ExtraBold", size: 17)
                            .foregroundColor(Color(.tertiaryLabel))
                        Spacer()
                    }
                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                start = true
            }
        }
    }
}

extension NewPersonView {
    func makeLineView(index: Int) -> some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.primary)
                .cornerRadius(120)
                .frame(width: start ? (index % 2 != 0) ? CGFloat(32.44) : CGFloat(17.69) : 0, height: 2.64, alignment: .leading)
                .animation(.timingCurve(0.87, 0, 0.13, 1, duration: 1).delay(Double(index)/Double(person.bestHeight)*0.6))
            
            Spacer()
        }
        .frame(height: 42)
        .overlay(
            makeOverlayLineView(rangeCenter: index)
        )
    }
    
    func makeOverlayLineView(rangeCenter: Int) -> some View {
        let floatCenter = Float(rangeCenter)
        let lineData = person.records.filter { record -> Bool in
            let left = floatCenter - 0.5
            let right = floatCenter + 0.5
            let height = record.height
            if height >= left && height < right {
                return true
            } else {
                return false
            }
        }
        
        func calOffset(_ height: Float) -> CGFloat {
            -CGFloat(height - floatCenter) * 42
        }
        
        return ZStack {
            ForEach(lineData){ data in
                ZStack(alignment: .trailing) {
                    
                    Color.clear
                    
                    Rectangle()
                        .fill(Color.girinOrange)
                        .frame(maxWidth: start ? .infinity : 0, alignment: .leading)
                        .frame(height: 2.64)
                        .cornerRadius(120)
                    HStack {
                        Text("\(data.height, specifier: "%.2f")cm")
                            .scaledFont(name: "Gilroy-ExtraBold", size: 12)
                        
                        Text(data.recordDate, style: .date)
                            .scaledFont(name: "Gilroy-ExtraBold", size: 12)
                    }.padding(.horizontal, 10)
                    .padding(.vertical, 2)
                    .offset(y: 8)
                    .opacity(start ? 1 : 0)
                    
                }.offset(y: calOffset(data.height))
                .animation(.timingCurve(0.87, 0, 0.13, 1, duration: 1).delay(Double(data.height/person.bestHeight)*0.6))
            }
        }
    }
}


struct RecordCellView: View {
    @EnvironmentObject var girinVM: GirinViewModel
    @Binding var person: Person
    var record: Record
    @State var showRemoveRecordAlert = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(record.height, specifier: "%.2f")cm")
                    .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 18)
                
                HStack(spacing: 6){
                    Text(record.recordDate, style: .date)
                    Text(record.recordDate, style: .time)
                }.scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 12)
            }
            Spacer()
            
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.girinOrange)
                .font(.title2)
                .onTapGesture{
                    showRemoveRecordAlert = true
                }
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .foregroundColor(Color(.secondarySystemBackground)), alignment: .center)
        .alert(isPresented: $showRemoveRecordAlert) {
            Alert(title: Text("Remove Record"), message: Text("Are you sure you want to delete this record?"), primaryButton: .destructive(Text("OK"), action: {
                withAnimation(.spring()) {
                    person.records.removeAll { anyRecord in
                        anyRecord.id == record.id
                    }
                    girinVM.save() //
                }
            }), secondaryButton: .cancel())
        }
    }
}
