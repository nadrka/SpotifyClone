//
//  AlbumDetailsViewModel.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 03/04/2021.
//

import Foundation
import Combine

class AlbumViewModel {
    private var cancellables = Set<AnyCancellable>()
    let state = PassthroughSubject<State, Never>()
    
    let album: Album
    let browseService: BrowseService
    var details: Album.Details?
    
    init(album: Album, browseService: BrowseService = BrowseService()) {
        self.album = album
        self.browseService = browseService
    }
        
    func fetchDetails() {
        state.send(.loading)
        
        browseService.getAlbumDetails(album: album)
            .sink(receiveCompletion: { [weak self] result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    self?.state.send(.error)
                    print(error)
                }
            }) { [weak self] details in
                self?.details = details
                self?.state.send(.loaded)
            }.store(in: &cancellables)
    }
}


// MARK: Datasource
extension AlbumViewModel {
    var tracks: [Track] {
        details?.tracks.items ?? []
    }
    
    var numberOfTracks: Int {
        tracks.count
    }
    
    func getTrack(for row: Int) -> Track? {
        guard tracks.indices.contains(row) else {
            return nil
        }
        
        return tracks[row]
    }
}
