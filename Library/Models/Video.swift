//
//  Video.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 19/10/20.
//

import Foundation

struct Video: Decodable {
    let url: String
    let title: String
}

extension Video: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}

extension Video: Equatable {
    static func ==(lhs: Video, rhs: Video) -> Bool {
        return lhs.url == rhs.url
    }
}
