//
//  PosComponent.swift
//  Growing
//
//  Created by Kimyaehoon on 02/04/2021.
//

import SwiftUI
import Combine

struct BoundsPreferenceKey: PreferenceKey {
    typealias Value = Anchor<CGRect>?

    static var defaultValue: Value = nil

    static func reduce(
        value: inout Value,
        nextValue: () -> Value
    ) {
        value = nextValue()
    }
}

struct ExampleView: View {
    
    var body: some View {
        ZStack {
            Color.yellow
            Text("Hello World !!!")
                .anchorPreference(
                    key: BoundsPreferenceKey.self,
                    value: .bounds
                ) { $0 }
                
        }
        .overlayPreferenceValue(BoundsPreferenceKey.self) { preferences in
            GeometryReader { geometry in
                preferences.map {
                    Rectangle()
                        .stroke()
                        .frame(
                            width: geometry[$0].width,
                            height: geometry[$0].height
                        )
                        .offset(
                            x: geometry[$0].minX,
                            y: geometry[$0].minY
                        )
                }
            }
        }
    }
}
struct PosComponent_Previews: PreviewProvider {
    static var previews: some View {
        ExampleView()
    }
}

extension Notification {
    var keyboardHeight: CGFloat {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map{ value -> CGFloat in
                return value.keyboardHeight
            }

        
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map{_ in CGFloat(0)}
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
