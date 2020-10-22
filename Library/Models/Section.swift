//
//  Section.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 19/10/20.
//

import Foundation

struct Section: Decodable, Hashable {
    let title: String
    let videos: [Video]
    var identifier = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func ==(lhs: Section, rhs: Section) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}


