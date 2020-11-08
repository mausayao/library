//
//  BagdeSuplemantaryView.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 08/11/20.
//

import UIKit

class BadgeSuplemantaryView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: BadgeSuplemantaryView.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        backgroundColor = UIColor(named: "rw-green")
        let rarius = bounds.width / 2.0
        layer.cornerRadius = rarius
    }
}
