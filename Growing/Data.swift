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

struct Person: Codable, Identifiable {
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
    var thumbnail: String
    var birthday: Date
    var records: [Record]
    
    init() {
        self.name = ""
        self.favColor = .pink
        self.thumbnail = ""
        self.birthday = Date()
        self.records = []
    }
    
    init(name: String, favColor: SystemColor, thumbnail: String, birthday: Date, records: [Record]) {
        self.name = name
        self.favColor = favColor
        self.thumbnail = thumbnail
        self.birthday = birthday
        self.records = records
    }
    
    static let samplePerson: [Person] = [
        Person(name: "우리 주니", favColor: .blue, thumbnail: "TestThumbnail", birthday: Date(), records: Record.sampleRecord),
        Person(name: "예빈이", favColor: .purple, thumbnail: "TestThumbnail", birthday: Date(), records: Record.sampleRecord),
        Person(name: "예이", favColor: .purple, thumbnail: "TestThumbnail", birthday: Date(), records: Record.sampleRecord),
        Person(name: "빈이", favColor: .purple, thumbnail: "TestThumbnail", birthday: Date(), records: Record.sampleRecord),
        Person(name: "예빈", favColor: .purple, thumbnail: "TestThumbnail", birthday: Date(), records: Record.sampleRecord),
        Person(name: "이이", favColor: .purple, thumbnail: "TestThumbnail", birthday: Date(), records: Record.sampleRecord)
    ]
    
}

struct Record: Codable, Identifiable {
    var id = UUID()
    var recordDate: Date
    var height: Float
    var pictures: [Picture]
    var title: String = "제목 없음"
    var text: String
    
    init() {
        self.recordDate = Date()
        self.height = 0
        self.pictures = []
        self.text = ""
    }
    
    init(recordDate: Date, height: Float, pictures: [Picture], text: String) {
        self.recordDate = recordDate
        self.height = height
        self.pictures = pictures
        self.text = text
    }
    
    static let sampleRecord: [Record] = [
        Record(recordDate: Date(), height: 23, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 23.6, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 23.3, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 22, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 20, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 30, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 110, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 100, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 41, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 20.6, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 21.3, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 28, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 34, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 40, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 113, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 120, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 53, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 53.6, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 53.3, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 52, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 50, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 60, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 130, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 140, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 133, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 133.6, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 134.3, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 150, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 144, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 137, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 139, pictures: [], text: "울 아들 화이팅"),
        Record(recordDate: Date(), height: 101, pictures: [], text: "울 아들 화이팅")
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


