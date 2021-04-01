//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 27/02/2021.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    typealias Section = HomeViewModel.Section
    
    private var cancellables = Set<AnyCancellable>()
    let viewModel: HomeViewModel
    
    private lazy var layout = makeCompositionalLayout()
    private lazy var collectionView = makeCollectionView()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        
        viewModel.state.sink { [weak self] state in
            switch state {
            case .loading:
                print("show loader")
            case .loaded:
                print("reload data")
                self?.collectionView.reloadData()
            case .error:
                print("show error")
            }
        }.store(in: &cancellables)
        
        view.addSubview(collectionView)

        viewModel.fetchData()
        
    }
    
    private func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGroupedBackground
        
        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.reusableIdentifier)
        collectionView.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: PlaylistCollectionViewCell.reusableIdentifier)
        collectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedCollectionViewCell.reusableIdentifier)
        
        return collectionView
    }
    
    @objc private func didTapSettings() {
        viewModel.handleSettingsButtonTap()
//        let vm = SettingsViewModel()
//        let vc = SettingsViewController(viewModel: vm)
//        
//        vc.title = "Settings"
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
    }
}


// MARK: Data source
extension HomeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfRow(for: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = Section(rawValue: indexPath.section)
        
        switch section {
        case .playlist:
            return makePlayListCell(indexPath: indexPath)
        case .realeases:
            return makeReleasesCell(indexPath: indexPath)
        case .recommandation:
            return makeRecommandationCell(indexPath: indexPath)
        case nil:
            return UICollectionViewCell()
        }
    }
    
    func makePlayListCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaylistCollectionViewCell.reusableIdentifier, for: indexPath) as? PlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let playlist = viewModel.getPlaylist(for: indexPath.row) {
            cell.configure(with: playlist)
        }
    
        return cell
    }
    
    func makeReleasesCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.reusableIdentifier, for: indexPath) as? NewReleaseCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let album = viewModel.getRelease(for: indexPath.row) {
            cell.configure(with: album)
        }
        return cell
    }
    
    func makeRecommandationCell(indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedCollectionViewCell.reusableIdentifier, for: indexPath) as? RecommendedCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let track = viewModel.getRecommandation(for: indexPath.row) {
            cell.configure(with: track)
        }
        return cell
    }
}


// MARK: Layout
extension HomeViewController {
    private func makeCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            guard let section = Section(rawValue: sectionIndex) else {
                return nil
            }
            switch section {
            case .realeases:
                return self.makeFeatureSectionLayout()
            case .playlist:
                return self.makePlaylistSectionLayout()
            case .recommandation:
                return self.makeRecommandationSectionLayout(layoutEnvironment: layoutEnvironment)
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        
        return layout
    }
    
    private func makeFeatureSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 0, trailing: 0)
        
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let verticalLayoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitem: item, count: 3)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalHeight(0.35))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [verticalLayoutGroup])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func makePlaylistSectionLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 0, trailing: 0)
        
        let verticalGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
        let verticalLayoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: verticalGroupSize, subitems: [item])
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.95), heightDimension: .estimated(420))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [verticalLayoutGroup])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return section
    }
    
    private func makeRecommandationSectionLayout(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection.list(using: .init(appearance: .plain), layoutEnvironment: layoutEnvironment)
        section.interGroupSpacing = 4
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
        return section
    }
}

// MARK: Collection Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        viewModel.handleTap(indexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = UIColor.systemGroupedBackground.withAlphaComponent(0.3)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.backgroundColor = nil
        }
    }
}
