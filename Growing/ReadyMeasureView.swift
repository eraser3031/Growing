//
//  ReadyMeasureView.swift
//  Growing
//
//  Created by Kimyaehoon on 10/05/2021.
//

import SwiftUI

struct ReadyMeasureView: View {
    @EnvironmentObject var girinVN: GirinViewModel
    @ObservedObject var placeSet: PlaceSetting
    @Binding var person: Person
    @State var resultHeight: Float = 0
    @State var showResultMeasureView = false
    var dismiss: () -> Void
    var body: some View {
        VStack {
            HStack {
                Text("Measure")
                    .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 34)

                Spacer()
                
                //  MARK: - ReadyMeasureView Cancel Button
                ZStack {
                    Circle()
                        .fill(Color.second)
                        .frame(width: 34, height:34)
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.title3)
                }
                .onTapGesture {
                    dismiss()
                }
                //  MARK: -
            }
            .padding(.horizontal, 20)
            
            Spacer()
            //
            VStack{
                VStack(spacing: 4) {
                    Image(uiImage: person.thumbnail.toImage() ?? UIImage())
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .mask(Circle())
                        .frame(width: 64, height: 64)
                        
                    Text(person.name)
                        .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 12)
                }
                
                //  MARK: - ReadyMeasureView Measure Button
                Button(action: {
                    resultHeight = placeSet.measureHeight
                    showResultMeasureView = true
                }) {
                    ZStack {
                        Circle()
                            .frame(width: screen.width-120, height: screen.width-120)
                            .foregroundColor(Color(.systemBackground))
                            .shadow(color: Color(.displayP3, red: 92/255, green: 103/255, blue: 153/255).opacity(0.2), radius: 40, x: 0, y: 20)
                        
                        Text("\(placeSet.measureHeight, specifier: "%.2f")cm")
                            .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 34)
                    }
                }.buttonStyle(PlainButtonStyle())
                .fullScreenCover(isPresented: $showResultMeasureView) {
                    ResultMeasureView(placeSet: placeSet, person: $person, height: $resultHeight, dismiss: {
                        showResultMeasureView = false
                    }, dismissOuter: {
                        showResultMeasureView = false
                        dismiss()
                    })
                    .environmentObject(girinVN)
                }
                //  MARK: -

            }.offset(y: -64)
            
            Spacer()
            Text("Put your iphone on top of your head\nand Press the Circle")
                .multilineTextAlignment(.center)
                .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
        }
    }
}

struct ResultMeasureView: View {
    
    @EnvironmentObject var girinVN: GirinViewModel
    @ObservedObject var placeSet: PlaceSetting
    @Binding var person: Person
    @Binding var height: Float
    var dismiss: () -> Void
    var dismissOuter: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Spacer()
                
                //  MARK: - ResultMeasureView Cancel Button
                ZStack {
                    Circle()
                        .fill(Color.second)
                        .frame(width: 34, height:34)
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                        .font(.title3)
                }
                .onTapGesture {
                    dismissOuter()
                }
                //  MARK: -
            }

            Text("\(person.name)'s\n Height")
                .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 34)
            Text("\(height, specifier: "%.2f")cm")
                .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 60)
            
            Spacer()
            
            VStack{
                //  MARK: - ResultMeasureView Retry Button
                Button(action: {dismiss()}) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .foregroundColor(Color(.secondarySystemBackground))
                        
                        Text("retry")
                            .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
                    }
                }.buttonStyle(PlainButtonStyle())
                //  MARK: -
                
                //  MARK: - ResultMeasureView OK Button
                Button(action: {
                    person.records.append(Record(recordDate: Date(), height: height, text: ""))
                    dismissOuter()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .foregroundColor(Color.primary)
                        
                        Text("Save")
                            .scaledFont(name: CustomFont.Gilroy_ExtraBold.rawValue, size: 17)
                            .foregroundColor(Color(.systemBackground))
                    }
                }.buttonStyle(PlainButtonStyle())
                //  MARK: -
            }
        }
        .padding(.horizontal, 20)
    }
}

//struct ReadyMeasureView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReadyMeasureView()
//    }
//}
