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
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Video>!
    
    lazy var dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(coder: NSCoder, tutorial: Tutorial) {
        self.tutorial = tutorial
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.title = tutorial.title
        imageView.image = tutorial.image
        imageView.backgroundColor = tutorial.imageBackGroundColor
        titleLabel.text = tutorial.title
        publishDateLabel.text = tutorial.formattedDate(using: dateFormatter)
        
        let buttonTitle = tutorial.isQueued ? "Remove from queue" : "Add to queue"
        queueButton.setTitle(buttonTitle, for: .normal)
        
        collectionView.register(TitleSuplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSuplementaryView.reuseIdentifier)
       
        collectionView.collectionViewLayout = configureCollectionView()
        configureDataSource()
        configureSnapshot()
    }
    
    @IBAction func toogleQueued(_ sender: UIButton) {
        tutorial.isQueued.toggle()
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

// MARK: - Collection View -
extension TutorialDetailController {
    func configureCollectionView() -> UICollectionViewLayout {
       
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 20, trailing: 10)
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
            
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
    }
}

// MARK: - DataSource COnfigure -
extension TutorialDetailController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Video>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, video: Video) in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCell.reuseIdetifier, for: indexPath) as? ContentCell else {
                return nil
            }
            
            cell.textLabel.text = video.title
            return cell
        }
        
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            
            if let self = self, let titleSuplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TitleSuplementaryView.reuseIdentifier, for: indexPath) as? TitleSuplementaryView {
                
                let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                titleSuplementary.textLabel.text = section.title
                return titleSuplementary
            } else {
                fatalError("Cannot create new supplementary")
            }
            
            return nil
        }
    }
    
    func configureSnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<Section, Video>()
        
        tutorial.content.forEach { section in
            currentSnapshot.appendSections([section])
            currentSnapshot.appendItems(section.videos)
        }
        
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}
