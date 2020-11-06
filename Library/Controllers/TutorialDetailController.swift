//
//  TutorialDetailController.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 19/10/20.
//

import UIKit

class TutorialDetailController: UIViewController {
    
    static let identifier = String(describing: TutorialDetailController.self)
    private let tutorial: Tutorial

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var queueButton: UIButton!
    
    lazy var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(coder: NSCoder, tutorial: Tutorial) {
        self.tutorial = tutorial
        super.init(coder: coder)
    }
    
    private func setupView() {
        self.title = tutorial.title
        imageView.image = tutorial.image
        imageView.backgroundColor = tutorial.imageBackGroundColor
        titleLabel.text = tutorial.title
        publishDateLabel.text = tutorial.formattedDate(using: dateFormatter)
        
        let buttonTitle = tutorial.isQueued ? "Remove from queue" : "Add to queue"
        queueButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func toogleQueued(_ sender: UIButton) {
        UIView.performWithoutAnimation {
            if tutorial.isQueued {
                queueButton.setTitle("Remove from queue", for: .normal)
            } else {
                queueButton.setTitle("Add to queue", for: .normal)
            }
            
            self.queueButton.layoutIfNeeded()
        }
    }
    
}
