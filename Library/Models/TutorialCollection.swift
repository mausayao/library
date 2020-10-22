//
//  TutorialCollection.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 19/10/20.
//

import Foundation

struct TutorialCollection: Decodable, Hashable {
    let title: String
    let tutorials: [Tutorial]
    var identifier = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func ==(lhs: TutorialCollection, rhs: TutorialCollection) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}
