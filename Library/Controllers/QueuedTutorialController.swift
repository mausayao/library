//
//  QueuedTutorialController.swift
//  Library
//
//  Created by Maurício de Freitas Sayão on 19/10/20.
//

import UIKit

class QueuedTutorialController: UIViewController {
    
    static let badgeElementKind = "badge-element-kind"
    
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
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureSnapshot()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) {
            [weak self] _ in
            guard let self = self else {return}
            self.triggerUpdates()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                [weak self] in
                guard let self = self else {return}
                self.applyUpdates()
            }
        }
    }
    
    func setupView() {
        self.title = "Queue"
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.rightBarButtonItem = nil
        collectionView.register(BadgeSuplemantaryView.self, forSupplementaryViewOfKind: QueuedTutorialController.badgeElementKind, withReuseIdentifier: BadgeSuplemantaryView.reuseIdentifier)
        
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
    
    @IBAction func triggerUpdates() {
        let indexPath = collectionView.indexPathsForVisibleItems
        let randomIndex = indexPath[Int.random(in: 0..<indexPath.count)]
        let tutorial = dataSource.itemIdentifier(for: randomIndex)
        tutorial?.updateCount = 3
        
        let badgeView = collectionView.supplementaryView(forElementKind: QueuedTutorialController.badgeElementKind, at: randomIndex)
        badgeView?.isHidden = false
        
    }
    
    @IBAction func applyUpdates() {
        let tutorials = dataSource.snapshot().itemIdentifiers
        
        if var firstTutorial = tutorials.first, tutorials.count > 2 {
            let tutorialsWithUpdate = tutorials.filter { $0.updateCount > 0}
            var currentSnapShot = dataSource.snapshot()
            
            tutorialsWithUpdate.forEach { (tutorial) in
                if tutorial != firstTutorial {
                    currentSnapShot.moveItem(tutorial, beforeItem: firstTutorial)
                    firstTutorial = tutorial
                    tutorial.updateCount = 0
                }
                
                if let indexPath = dataSource.indexPath(for: tutorial) {
                    let badgeView = collectionView.supplementaryView(forElementKind: QueuedTutorialController.badgeElementKind, at: indexPath)
                    badgeView?.isHidden = true
                }
            }
            
            dataSource.apply(currentSnapShot, animatingDifferences: true)
        }
    }
    
}
// MARK: - Configura Collection View -
extension QueuedTutorialController {
    func configuraCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let anchorEdges: NSDirectionalRectEdge = [.top, .trailing]
        let offset = CGPoint(x: 0.1, y: 0.3)
        let badgeAnchor = NSCollectionLayoutAnchor(edges: anchorEdges, fractionalOffset: offset)
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20), heightDimension: .absolute(20))
        let badge = NSCollectionLayoutSupplementaryItem(layoutSize: badgeSize, elementKind: QueuedTutorialController.badgeElementKind, containerAnchor: badgeAnchor)
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        
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
        
        dataSource.supplementaryViewProvider = { [weak self](
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in
            
            guard
                let self = self,
                let tutorial = self.dataSource.itemIdentifier(for: indexPath),
                let badgeView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BadgeSuplemantaryView.reuseIdentifier, for: indexPath) as? BadgeSuplemantaryView
            else {
                return nil
            }
            
            if tutorial.updateCount > 0 {
                badgeView.isHidden = false
            } else {
                badgeView.isHidden = true
            }
            
            return badgeView
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
