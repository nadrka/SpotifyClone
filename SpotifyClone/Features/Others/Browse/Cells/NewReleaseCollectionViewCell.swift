//
//  NewReleaseCollectionViewCell.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 30/03/2021.
//

import UIKit
import SnapKit
import Kingfisher

struct NewReleaseCellViewModel {
    let albumCover: String
    let albumName: String
    let artistName: String
    let nubmerOfTracks: Int
    
    var albumCoverURL: URL? {
        URL(string: albumCover)
    }
}

class NewReleaseCollectionViewCell: UICollectionViewCell {
    static let reusableIdentifier = "NewReleaseCollectionViewCell"
    
    private let albumCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Łączyno 6 wariatów"
        label.font = .preferredFont(forTextStyle: .headline)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.text = "Tracks: 1"
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Karol"
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .secondarySystemGroupedBackground
        layer.cornerRadius = 5
        addSubviews(albumCoverImage, albumNameLabel, numberOfTracksLabel, artistNameLabel)
        applyConstraints()
    }
    
    private func applyConstraints() {
        albumCoverImage.snp.makeConstraints { make in
            make.height.equalToSuperview().inset(4)
            make.width.equalTo(albumCoverImage.snp.height)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(4)
        }
        albumNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumCoverImage.snp.trailing).offset(8)
            make.top.equalToSuperview().inset(4)
            make.right.equalToSuperview().inset(4)
        }
        artistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumCoverImage.snp.trailing).offset(8)
            make.top.equalTo(albumNameLabel.snp.bottom).offset(4)
            make.right.equalToSuperview().inset(4)
        }
        
        numberOfTracksLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumCoverImage.snp.trailing).offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(4)
        }
    }
    
    func configure(with release: Album) {
        albumNameLabel.text = release.name
        artistNameLabel.text = release.artists.first?.name ?? ""
        numberOfTracksLabel.text = "Tracks: \(release.totalTracks)"
        let imageURLString = release.images.first?.url ?? ""
        if let url =  URL(string: imageURLString) {
            albumCoverImage.kf.setImage(with: url)
        }
    }
}
