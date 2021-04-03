//
//  AlbumViewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 01/04/2021.
//

import UIKit
import Combine

enum OnlyMainSection {
    case main
}

class AlbumViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<OnlyMainSection, Track>
    private var cancellables = Set<AnyCancellable>()
    let viewModel: AlbumViewModel
    
    private lazy var layout = makeLayout()
    private lazy var collectionView = makeCollectionView()
    private lazy var dataSource: DataSource = makeDataSource()
    
    init(viewModel: AlbumViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        collectionView.dataSource = dataSource
        collectionView.register(TrackCollectionViewCell.self, forCellWithReuseIdentifier: TrackCollectionViewCell.reusableIdentifier)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loading: print("show loader")
                case .loaded: self?.loadData()
                case .error: break
                }
            }.store(in: &cancellables)
        
        viewModel.fetchDetails()
    }
    
    private func makeCollectionView() -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        return collectionView
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout.list(using: .init(appearance: .plain))
        
        return layout
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource (
            collectionView: collectionView,
            cellProvider: makeCellRegistration().cellProvider
        )
        
        return dataSource
    }
    
    
    private func loadData() {
        var snapshot = NSDiffableDataSourceSnapshot<OnlyMainSection, Track>()
        snapshot.appendSections([OnlyMainSection.main])
        snapshot.appendItems(viewModel.tracks, toSection: OnlyMainSection.main)
        
        dataSource.apply(snapshot)
    }
    
}

extension AlbumViewController {
    typealias Cell = TrackCollectionViewCell
    typealias CellRegistration = UICollectionView.CellRegistration<Cell, Track>
    
    private func makeCellRegistration() -> CellRegistration {
        CellRegistration { cell, index, track in
            cell.configure(with: track)
        }
    }
}
