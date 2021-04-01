//
//  SettingsViewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 25/03/2021.
//

import UIKit
import SnapKit

class SettingsViewController: UIViewController, UICollectionViewDelegate {
    typealias Section = SettingsViewModel.Section
    typealias Item = SettingsViewModel.Option
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    
    private static let cellReuseID = "product-cell"
    
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource: DataSource = makeDataSource()
    
    let viewModel: SettingsViewModel
    
    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        
        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: Self.cellReuseID)
        
        collectionView.backgroundColor = .systemGroupedBackground
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        
        loadData()
    }
    
    private func makeCollectionView() -> UICollectionView {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.headerMode = .supplementary
        
        let layout = UICollectionViewCompositionalLayout.list(
            using: configuration
        )

        return UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: collectionView,
            cellProvider: makeCellRegistration().cellProvider
        )
        
        let headerRegistration = makeHeaderRegistration()
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        return dataSource
    }
    
    private func loadData() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections(viewModel.sections)
        
        for section in viewModel.sections {
            snapshot.appendItems(section.options, toSection: section)
        }
        
        dataSource.apply(snapshot)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let option = self.dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        
        handleTap(for: option)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    private func handleTap(for option: Item) {
        switch option {
        case .viewProfile:
            showProfile()
        case .signOut:
            signOut()
        }
    }
    
    private func showProfile() {
        let vc = ProfileViewController()
        vc.title = "Profile"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func signOut() {
        
    }
   
}


private extension SettingsViewController {
    typealias Cell = UICollectionViewListCell
    typealias CellRegistration = UICollectionView.CellRegistration<Cell, Item>
    typealias HeaderRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>
    
    func makeCellRegistration() -> CellRegistration {
        CellRegistration { cell, indexPath, option in
            var config = cell.defaultContentConfiguration()
            config.text = option.rawValue
            cell.contentConfiguration = config
        }
    }
    
    
    func makeHeaderRegistration() -> HeaderRegistration {
        HeaderRegistration(elementKind: UICollectionView.elementKindSectionHeader) {
            [unowned self] (headerView, elementKind, indexPath) in
            
            // Obtain header item using index path
            let headerItem = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            // Configure header view content based on headerItem
            var configuration = headerView.defaultContentConfiguration()
            configuration.text = headerItem.title
            
            // Customize header appearance to make it more eye-catching
            configuration.textProperties.font = .boldSystemFont(ofSize: 15)
            configuration.textProperties.color = UIColor.label.withAlphaComponent(0.9)
            configuration.directionalLayoutMargins = .init(top: 20.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
            
            // Apply the configuration to header view
            headerView.contentConfiguration = configuration
        }
    }
}


