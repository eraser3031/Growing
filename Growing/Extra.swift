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
    static let main = UIColor(named:"main")
    static let second = UIColor(named:"second")
    static let mainDark = UIColor(named:"mainDark")
    static let secondDark = UIColor(named:"secondDark")
    
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

extension Data {
    
}
