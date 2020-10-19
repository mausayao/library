//
//  Tutorial.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 19/10/20.
//

import UIKit

class Tutorial {
    let title: String
    let thumbnail: String
    let artworkColor: String
    let isQueued: Bool
    let publishDate: Date
    let content: [Section]
    let updateCount: Int
    
    init(title: String, thumbnail: String, artworkColor: String, isQueued: Bool, publishDate: Date, content: [Section], updateCount: Int) {
        self.title = title
        self.thumbnail = thumbnail
        self.artworkColor = artworkColor
        self.isQueued = isQueued
        self.publishDate = publishDate
        self.content = content
        self.updateCount = updateCount
    }
}

extension Tutorial {
    var image: UIImage? {
        return UIImage(named: thumbnail)
    }
    
    var imageBackGroundColor: UIColor? {
        return UIColor(named: artworkColor)
    }
    
    func formattedDate(using formatter: DateFormatter) -> String? {
        return formatter.string(from: publishDate)
    }
}
