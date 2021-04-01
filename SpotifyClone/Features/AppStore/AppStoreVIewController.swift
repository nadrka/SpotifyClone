//
//  AppStoreVIewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 18/03/2021.
//

import UIKit



final class AppStoreViewController: UIViewController {
    let sections = Bundle.main.decode([Section].self, from: "appstore.json")
    
    private lazy var collectionViewLayout = makeCompositionalLayout()
    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, App> = makeDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Apps"
        

        collectionView.register(FeaturedCell.self, forCellWithReuseIdentifier: FeaturedCell.reuseIdentifier)
        collectionView.register(MediumTableCell.self, forCellWithReuseIdentifier: MediumTableCell.reuseIdentifier)
        collectionView.dataSource = dataSource

        reloadData()
    }
    
    private func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: collectionViewLayout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        return collectionView
    }

    private func makeDataSource() -> UICollectionViewDiffableDataSource<Section, App>{
        return UICollectionViewDiffableDataSource<Section, App> (
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, app in
                switch self.sections[indexPath.section].type {
                case "mediumTable":
                    return self.configure(MediumTableCell.self, with: app, for: indexPath)
                default:
                    return self.configure(FeaturedCell.self, with: app, for: indexPath)
                }
            }
        )
    }

    private func configure<T: SelfConfiguringCell>(_ cellType: T.Type, with app: App, for indexPath: IndexPath) -> T {
        guard let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Unable to deque \(cellType)")
        }
        cell.configure(with: app)
        return cell
    }

    func reloadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, App>()
        snapshot.appendSections(sections)

        for section in sections {
            snapshot.appendItems(section.items, toSection: section)
        }

        dataSource.apply(snapshot)
    }
    
    
   private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let section = self.sections[sectionIndex]

            switch section.type {
            case "mediumTable":
                return self.createMediumTableSection(using: section)
            default:
                return self.createFeaturedSection(using: section)
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        return layout
    }
    
    private func createFeaturedSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .estimated(350))
        let layoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered
        return layoutSection
    }
     
    func createMediumTableSection(using section: Section) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))

        let layoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        layoutItem.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        let layoutGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.93), heightDimension: .fractionalWidth(0.55))
        let layoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: layoutGroupSize, subitems: [layoutItem])

        let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
        layoutSection.orthogonalScrollingBehavior = .groupPagingCentered

//        let layoutSectionHeader = createSectionHeader()
//        layoutSection.boundarySupplementaryItems = [layoutSectionHeader]

        return layoutSection
    }
}
