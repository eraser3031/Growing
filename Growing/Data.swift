//
//  Data.swift
//  Growing
//
//  Created by Kimyaehoon on 07/03/2021.
//

import SwiftUI

final class GirinViewModel: ObservableObject {
    @Published var personList: [Person] = Storage.retrive("PersonList.json", from: .documents, as: [Person].self) ?? [Person.samplePerson]

}

struct Person: Codable, Identifiable {
    var id = UUID()
    var name: String
    var favColor: SystemColor
    var nowHeight: Float {
        1.0
    }
    var birthday: Date
    var records: [Record]
    
    static let samplePerson = Person(name: "우리 주니", favColor: .blue, birthday: Date(), records: [])
}

struct Record: Codable, Identifiable {
    var id = UUID()
    var recordDate: Date
    var height: Float
    var pictures: [String]
    var text: String
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


