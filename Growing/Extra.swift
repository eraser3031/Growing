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

extension Date {
    func toAge() -> Int {
        Date().year - self.year
    }
}

extension Data {
    func toImage() -> UIImage? {
            return UIImage(data: self)
    }
}

extension UIImage {
    func toData() -> Data? {
        self.pngData() ?? self.jpegData(compressionQuality: 1)
    }
}



//dynamic custom font
@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
struct ScaledFont: ViewModifier {
    @Environment(\.sizeCategory) var sizeCategory
    var name: String
    var size: CGFloat

    func body(content: Content) -> some View {
       let scaledSize = UIFontMetrics.default.scaledValue(for: size)
        return content.font(.custom(name, size: scaledSize))
    }
}

@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
extension View {
    func scaledFont(name: String, size: CGFloat) -> some View {
        return self.modifier(ScaledFont(name: name, size: size))
    }
}

//정규표현식
extension String{
    func getArrayAfterRegex(regex: String) -> [String] {
        
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func hasEng() -> Bool {
        self.getArrayAfterRegex(regex: "[a-zA-Z]").count != 0
    }
}

