//
//  HomeViewModel.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 28/03/2021.
//

import Foundation
import Combine

enum State {
    case loading
    case loaded
    case error
}

enum Action {
    case settings
    case playlistDetails(playlist: Playlist)
    case releaseDetails(release: Album)
    case recommandationDetails(track: Track)
}

class HomeViewModel {
    private var cancellables = Set<AnyCancellable>()
    private(set) var state: PassthroughSubject<State, Never> = .init()
    private(set) var action: PassthroughSubject<Action, Never> = .init()
    
    let browseService: BrowseService
    
    var albums = [Album]()
    var playlists = [Playlist]()
    var recommandations = [Track]()
    
    
    init(browseService: BrowseService = BrowseService()) {
        self.browseService = browseService
    }
    
    func fetchData() {
        let releasePublisher = browseService.getAllNewReleases()
        let playlistPubliser = browseService.getFeaturedPlaylists()
        let recommandationPublisher = browseService.getRecommendation()
        
        state.send(.loading)
        releasePublisher.zip(playlistPubliser, recommandationPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished: break
                case .failure(let error):
                    print(error)
                    self?.state.send(.error)
                }
            }, receiveValue: { [weak self] release, playlist, recommandation in
                self?.albums = release.albums.items
                self?.playlists = playlist.playlists.items
                self?.recommandations = recommandation.tracks
                self?.state.send(.loaded)
            }).store(in: &cancellables)
    }
    
    @objc func handleSettingsButtonTap() {
        print("Show settings screen")
        action.send(.settings)
    }
    
    func handleTap(indexPath: IndexPath) {
        let section = Section(rawValue: indexPath.section)
        let row = indexPath.row
        
        switch section {
        case .playlist:
            guard let playlist = getPlaylist(for: row) else {
                return
            }
            print("show Playlist details")
            action.send(.playlistDetails(playlist: playlist))
        case .realeases:
            guard let release = getAlbum(for: row) else {
                return
            }
            action.send(.releaseDetails(release: release))
            print("show Release details")
        case .recommandation:
            guard let recommandation = getRecommandation(for: row) else {
                return
            }
            action.send(.recommandationDetails(track: recommandation))
            print("show Recommandation details")
        case nil: return
        }
    }
}

// MARK: Datasource for view controller
extension HomeViewModel {
    func numberOfRow(for sectionIndex: Int) -> Int{
        let section = Section(rawValue: sectionIndex)
        switch section {
        case .realeases: return albums.count
        case .playlist: return playlists.count
        case .recommandation: return recommandations.count
        case nil: return 0
        }
    }
    
    func getAlbum(for row: Int) -> Album? {
        return albums.indices.contains(row) ? albums[row] : nil
    }
    
    func getPlaylist(for row: Int) -> Playlist? {
        return playlists.indices.contains(row) ? playlists[row] : nil
    }
    
    func getRecommandation(for row: Int) -> Track? {
        return recommandations.indices.contains(row) ? recommandations[row] : nil
    }
}

extension HomeViewModel {
    enum Section: Int, CaseIterable {
        case realeases
        case playlist
        case recommandation
    }
    
}
