//
//  EditPersonView.swift
//  Growing
//
//  Created by Kimyaehoon on 28/03/2021.
//

import SwiftUI
import Combine

struct EditPersonView: View {
    @EnvironmentObject var girinVM: GirinViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Binding var person: Person
    @State var emptyPerson = Person()
    @State var keyboardOffset: CGFloat = 0
    @State var showImagePicker = false
    @State private var inputImage: UIImage?
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        person.thumbnail = inputImage.toData() ?? Data()
    }
    
    var endEdit: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Edit Kid".localized())
                    .scaledFont(name: "Gilroy-ExtraBold", size: 28)
                
                Spacer()
                
                //  MARK: - EditPersonView Cancel Button
                ZStack {
                    Circle()
                        .fill(Color.second)
                        .frame(width: 34, height:34)
                    
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .font(.title3)
                }
                .onTapGesture {
                    withAnimation(.spring()) {
                        person = emptyPerson
                        hideKeyboard()
                        endEdit()
                    }
                }
                // MARK: -
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
                
                Text("Profile Picture".localized())
                    .scaledFont(name: "Gilroy-ExtraBold", size: 15)
            }
            
            VStack(alignment: .leading){
                Text("Name".localized())
                    .scaledFont(name: "Gilroy-ExtraBold", size: 15)
                
                TextField("Please write kid's name.".localized(), text: $person.name)
                    .padding()
                    .frame(height: 45)
                    .background(Color.second)
                    .cornerRadius(12)
            }
            
            VStack(alignment: .leading, spacing: 0){
                Text("Birthday".localized())
                    .scaledFont(name: "Gilroy-ExtraBold", size: 15)
                
                HStack(spacing: 0) {
                    Text(String(format: NSLocalizedString("%d years", comment: ""), person.birthday.toAge()))
                        .scaledFont(name: "Gilroy-ExtraBold", size: 18)
                    
                    Spacer()
                    
                    DatePicker("", selection: $person.birthday, displayedComponents: .date)
                        .accentColor(.girinOrange)
                }.padding()
                .frame(height: 45)
                .background(Color.second)
                .cornerRadius(12)
            }
            .padding(.bottom, 40)
            
            //  MARK: - EditPersonView Confirm Button
            Button(action: {
                withAnimation(.spring()){
                    endEdit()
                }
                hideKeyboard()
                girinVM.save()
            }) {
                Text("Confrim".localized())
                    .scaledFont(name: "Gilroy-ExtraBold", size: 17)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.girinYellow)
                    .cornerRadius(12)
                    .padding(.bottom, UIApplication.shared.windows.filter{$0.isKeyWindow}.first!.safeAreaInsets.bottom)
            }
            .disabled(person.thumbnail == Data() || person.name == "")
            .opacity((person.thumbnail == Data() || person.name == "") ? 0.6 : 1)
            .buttonStyle(PlainButtonStyle())
            //  MARK: -
        }
        .if(horizontalSizeClass == .regular){ body in
            body
                .frame(width: 375)
        }
        .frame(height: 600)
        .padding(.horizontal, 20)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onReceive(Publishers.keyboardHeight){ height in
            if horizontalSizeClass == .compact {
                withAnimation(.spring()) {
                    keyboardOffset = height
                }
            }
        }
        .offset(x: 0, y: -keyboardOffset)
        .edgesIgnoringSafeArea(.bottom)
        .onAppear{
            emptyPerson = person
        }
    }
}


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
