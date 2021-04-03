//
//  HomeFlow.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 01/04/2021.
//

import Foundation
import Combine

class HomeFlow: Flow {
    private var cancellables = Set<AnyCancellable>()
    let homeViewController: HomeViewController
    
    init(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
    }
    
    func start() {
        homeViewController.viewModel.action.sink { [weak self] action in
            switch action {
            case .settings:
                self?.showSettingsScreen()
            case .releaseDetails(let release):
                self?.showReleaseDetailsScreen(for: release)
            case .playlistDetails(let playlist):
                self?.showPlaylistDetailsScreen(for: playlist)
            case .recommandationDetails(let track):
                self?.showRecommandationDetailsScreen(for: track)
            }
        }.store(in: &cancellables)
    }
    
    private func showSettingsScreen() {
        let vm = SettingsViewModel()
        let vc = SettingsViewController(viewModel: vm)
        
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        homeViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showReleaseDetailsScreen(for album: Album) {
        let vm = AlbumViewModel(album: album)
        let vc = AlbumViewController(viewModel: vm)
        vc.title = album.name
        vc.navigationItem.largeTitleDisplayMode = .never
        homeViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPlaylistDetailsScreen(for playlist: Playlist) {
        let vm = PlaylistDetailsViewModel(playlist: playlist)
        let vc = PlaylistViewController(viewModel: vm)
        vc.title = playlist.name
        vc.navigationItem.largeTitleDisplayMode = .never
        homeViewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showRecommandationDetailsScreen(for track: Track) {
        
    }
    
}
