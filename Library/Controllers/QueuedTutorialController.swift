//
//  QueuedTutorialController.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 19/10/20.
//

import UIKit

class QueuedTutorialController: UIViewController {
    
    enum Section {
        case main
    }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()
    
    
    @IBOutlet var updateButton: UIBarButtonItem!
    @IBOutlet var applyUpdatesButton: UIBarButtonItem!
    @IBOutlet var deleteButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Tutorial>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSnapshot()
    }
    
    func setupView() {
        self.title = "Queue"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = nil
        isEditing = false
        
        collectionView.collectionViewLayout = configuraCollectionViewLayout()
        configureDataSource()
    }
    
    @IBAction func deleteSelectedItems(_ sender: UIBarButtonItem) {
        
    }
    
}
// MARK: - Nav bar -
extension QueuedTutorialController {
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if isEditing {
            navigationItem.rightBarButtonItems = nil
            navigationItem.rightBarButtonItem = deleteButton
        } else {
            navigationItem.rightBarButtonItem = nil
            navigationItem.rightBarButtonItems = [self.applyUpdatesButton, self.updateButton]
        }

        collectionView.allowsMultipleSelection = true
        collectionView.indexPathsForVisibleItems.forEach { indexPath in
            guard let cell = collectionView.cellForItem(at: indexPath) as? QueueCell else { return }
            cell.isEditing = isEditing

            if !isEditing {
                cell.isSelected = false
            }
        }
    }
    
    @IBAction func deleteItems() {
        // Itens selecionados
        guard let selectedIndexPath = collectionView.indexPathsForSelectedItems else { return }
        
        // Tutorials selecionados
        let tutorials = selectedIndexPath.compactMap { dataSource.itemIdentifier(for: $0) }
        
        let queuedTutorials = DataSource.shared.tutorials.flatMap { $0.queuedTutorial }
        let tutorialsToUnqueued = Set(tutorials).intersection(queuedTutorials)
        tutorialsToUnqueued.forEach { $0.isQueued = false}
        
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.deleteItems(tutorials)
        
        dataSource.apply(currentSnapshot, animatingDifferences: true)
        
        isEditing.toggle()
        
    }
    
}
// MARK: - Configura Collection View -
extension QueuedTutorialController {
    func configuraCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(148))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - Configure Data Source -

extension QueuedTutorialController {
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Tutorial>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, tutorial: Tutorial) in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QueueCell.reuseIdentifier, for: indexPath) as? QueueCell else {
                return nil
            }
            
            cell.titleLabel.text = tutorial.title
            cell.thumbnailImageView.backgroundColor = tutorial.imageBackGroundColor
            cell.thumbnailImageView.image = tutorial.image
            cell.publishDateLabel.text = tutorial.formattedDate(using: self.dateFormatter)
            
            return cell
        }
    }
    
    func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Tutorial>()
        snapshot.appendSections([.main])
        
        let queuedTutorial = DataSource.shared.tutorials.flatMap { $0.queuedTutorial }
        snapshot.appendItems(queuedTutorial)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
