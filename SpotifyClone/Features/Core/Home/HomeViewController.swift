//
//  HomeViewController.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 27/02/2021.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    let browseService = BrowseService()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        
        fetchData()
    }
    
    private func fetchData() {
        browseService.getAllNewReleases()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error): print(error)
                }
            }, receiveValue: { realeses in
                print("Realeses loaded")
            }).store(in: &cancellables)
        
        browseService.getFeaturedPlaylists()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error): print(error)
                }
            }, receiveValue: { playlist in
                print("Playlist loaded")
            }).store(in: &cancellables)
        
        browseService.getRecommendation()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished: break
                case .failure(let error): print(error)
                }
            }, receiveValue: { recommandation in
                print("Recommandation loaded")
            }).store(in: &cancellables)
    }

    @objc private func didTapSettings() {
        let vm = SettingsViewModel()
        let vc = SettingsViewController(viewModel: vm)
        
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
