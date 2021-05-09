//
//  Data.swift
//  Growing
//
//  Created by Kimyaehoon on 07/03/2021.
//

import SwiftUI

final class GirinViewModel: ObservableObject {
    @Published var personList: [Person] = Storage.retrive("PersonList.json", from: .documents, as: [Person].self) ?? Person.samplePerson

}

struct Person: Codable, Identifiable, Equatable, Hashable {
    
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    var name: String
    var favColor: SystemColor
    var nowHeight: Float {
        if records.count == 0 {
            return 0
        } else {
            return records.last!.height
        }
    }
    var thumbnail: Data = Data()
    var birthday: Date
    var records: [Record]
    
    init() {
        self.name = ""
        self.favColor = .pink
        self.birthday = Date()
        self.records = []
    }
    
    init(name: String, favColor: SystemColor, birthday: Date, records: [Record]) {
        self.name = name
        self.favColor = favColor
        self.birthday = birthday
        self.records = records
    }
    
    static let samplePerson: [Person] = [
        Person(name: "우리 주니", favColor: .blue, birthday: Date(), records: Record.sampleRecord),
        Person(name: "예빈이", favColor: .purple, birthday: Date(), records: Record.sampleRecord),
        Person(name: "예이", favColor: .purple, birthday: Date(), records: Record.sampleRecord),
        Person(name: "빈이", favColor: .purple, birthday: Date(), records: Record.sampleRecord),
        Person(name: "예빈", favColor: .purple, birthday: Date(), records: Record.sampleRecord),
        Person(name: "이이", favColor: .purple, birthday: Date(), records: Record.sampleRecord)
    ]
    
}

struct Record: Codable, Identifiable, Hashable {
    static func == (lhs: Record, rhs: Record) -> Bool {
        lhs.id == rhs.id
    }
    
    var id = UUID()
    var recordDate: Date
    var height: Float
    var title: String = "제목 없음"
    var text: String
    
    init() {
        self.recordDate = Date()
        self.height = 0
        self.text = ""
    }
    
    init(recordDate: Date, height: Float, text: String) {
        self.recordDate = recordDate
        self.height = height
        self.text = text
    }
    
    static let sampleRecord: [Record] = [
        Record(recordDate: Date(), height: 23, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 23.6, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 23.3, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 22, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 20, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 30, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 110, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 100, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 41, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 20.6, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 21.3, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 28, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 34, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 40, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 113, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 120, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 53, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 53.6, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 53.3, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 52, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 50, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 60, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 130, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 140, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 133, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 133, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 134, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 150, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 144, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 137, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 139, text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 101, text: "울 아들 화이팅")
    ]
}

struct Picture: Codable, Identifiable {
    var id = UUID()
    var data: Data
}

enum SystemColor: String, Codable {
    case red
    case yellow
    case green
    case blue
    case purple
    case pink
    
    func toColor() -> Color {
        switch self {
        case .red:
            return Color(UIColor.systemRed)
        case .yellow:
            return Color(UIColor.systemYellow)
        case .green:
            return Color(UIColor.systemGreen)
        case .blue:
            return Color(UIColor.systemBlue)
        case .purple:
            return Color(UIColor.systemPurple)
        case .pink:
            return Color(UIColor.systemPink)
        }
    }
}

