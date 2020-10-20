//
//  ContentCell.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 20/10/20.
//

import UIKit

class ContentCell: UICollectionViewCell {
    static let reuseIdetifier = String(describing: ContentCell.self)
    
    @IBOutlet weak var textLabel: UILabel!
}
