//
//  QueueCell.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 20/10/20.
//

import UIKit

class QueueCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: QueueCell.self)
    
    var isEditing: Bool = false {
        didSet {
            checkBoxImageView.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected{
                checkBoxImageView.image = UIImage(systemName: "checkmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
            } else  {
                checkBoxImageView.image = UIImage(systemName: "checkmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large))
            }
        }
    }
    
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
}
