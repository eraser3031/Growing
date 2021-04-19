//
//  Extra.swift
//  Growing
//
//  Created by Kimyaehoon on 05/03/2021.
//

import SwiftUI
import Combine

let screen = UIScreen.main.bounds

extension Color {
    static let main = Color(UIColor(named:"main")!)
    static let second = Color(UIColor(named:"second")!)
    static let sub = Color(UIColor(named:"sub")!)
    static let girinYellow = Color(#colorLiteral(red: 1, green: 0.8, blue: 0.3019607843, alpha: 1))
    static let girinOrange = Color(#colorLiteral(red: 0.9568627451, green: 0.5647058824, blue: 0.04705882353, alpha: 1))

    // hex 변환 메소드 하나 구현 해놓기
}

extension Date {
    public var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    public var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    public var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    public var monthName: String {
        let nameFormatter = DateFormatter()
        nameFormatter.dateFormat = "MMMM" // format January, February, March, ...
        return nameFormatter.string(from: self)
    }
}

extension RandomAccessCollection {
    func indexed() -> Array<(offset: Int, element: Element)> {
    Array(enumerated())
    }
}

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}

public extension View {
  func `if`<T: View>(_ conditional: Bool, transform: (Self) -> T) -> some View {
    Group {
      if conditional { transform(self) }
      else { self }
    }
  }

  func `if`<T: View>(_ condition: Bool, true trueTransform: (Self) -> T, false falseTransform: (Self) -> T) -> some View {
    Group {
      if condition { trueTransform(self) }
      else { falseTransform(self) }
    }
  }
}

extension String {
    func toImage() -> UIImage? {
        if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
            return UIImage(data: data)
        }
        return nil
    }
}

extension UIImage {
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}
