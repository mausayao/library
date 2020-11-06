//
//  ViewController.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 19/10/20.
//

import UIKit

final class LibraryController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<TutorialCollection, Tutorial>!
    private let tutorialsCollections = DataSource.shared.tutorials
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        self.title = "Library"
        collectionView.delegate = self
        collectionView.register(TitleSuplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSuplementaryView.reuseIdentifier)
        collectionView.collectionViewLayout = configureCollectionViewLayout()
        configureDataSource()
        configureSnapshot()
    }
}

// MARK: - Collection View -

extension LibraryController {
    func configureCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.6), heightDimension: .fractionalHeight(0.3))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            section.interGroupSpacing = 10
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)
            
            section.boundarySupplementaryItems = [sectionHeader]
            
            return section
            
        }
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        
    }
}

extension LibraryController {
    typealias TutorialDataSource = UICollectionViewDiffableDataSource<TutorialCollection, Tutorial>
    
    func configureDataSource() {
        dataSource = TutorialDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, tutorial: Tutorial) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCell.reuseIdentifier, for: indexPath) as? TutorialCell else {return nil}
            cell.titleLabel.text = tutorial.title
            cell.thumbnailImageView.image = tutorial.image
            cell.thumbnailImageView.backgroundColor = tutorial.imageBackGroundColor
            cell.layer.cornerRadius = 10
            
            return cell
            
        }
        
        dataSource.supplementaryViewProvider = {[weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            if let self = self, let titleSuplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSuplementaryView.reuseIdentifier, for: indexPath) as? TitleSuplementaryView {
                let tutorialCollection = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
                titleSuplementaryView.textLabel.text = tutorialCollection.title
                return titleSuplementaryView
            } else {
                return nil
            }
            
        }
    }
    
    func configureSnapshot() {
        var currentSnapshot = NSDiffableDataSourceSnapshot<TutorialCollection, Tutorial>()
        
        tutorialsCollections.forEach { collection in
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.tutorials)
        }
        
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
}

// MARK: UICollectonViewDelegate

extension LibraryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tutoria = dataSource.itemIdentifier(for: indexPath),
           let tutorialDetailController = storyboard?.instantiateViewController(
            identifier: TutorialDetailController.identifier, creator: { coder  in
                return TutorialDetailController(coder: coder, tutorial: tutoria)
            }) {
            show(tutorialDetailController, sender: nil)
        }
    }
}
