//
//  PlaylistCollectionViewCell.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 30/03/2021.
//

import UIKit
import Kingfisher

class PlaylistCollectionViewCell: UICollectionViewCell {
    static let reusableIdentifier = "PlaylistCollectionViewCell"
    
    private let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.cornerRadius = 5
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = .preferredFont(forTextStyle: .footnote)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
//        backgroundColor = .secondarySystemBackground
        addSubviews(descriptionLabel, coverImage)
        applyConstraints()
    }
    
    private func applyConstraints() {
        coverImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(4)
            make.leading.trailing.equalToSuperview().inset(8)
        }
    }
    
    func configure(with playlist: Playlist) {
        descriptionLabel.text = playlist.description
        let imageURLString = playlist.images.first?.url ?? ""
        if let url =  URL(string: imageURLString) {
            coverImage.kf.setImage(with: url)
        }
    }
}
