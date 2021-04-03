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
        
    }
}
