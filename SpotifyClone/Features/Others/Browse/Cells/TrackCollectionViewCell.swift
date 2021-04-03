//
//  RecommendedCollectionViewCell.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 30/03/2021.
//

import UIKit

class TrackCollectionViewCell: UICollectionViewCell {
    static let reusableIdentifier = "TrackCollectionViewCell"
    
    private let albumCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
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
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Karol, Arczi, Lama"
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
        addSubviews(albumCoverImage, albumNameLabel, artistNameLabel)
        applyConstraints()
    }
    
    private func applyConstraints() {
        albumCoverImage.snp.makeConstraints { make in
            make.height.equalTo(0)
            make.width.equalTo(0)
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(4)
        }
        
        albumNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumCoverImage.snp.trailing).offset(8)
            make.top.equalToSuperview().inset(8)
            make.right.equalToSuperview().inset(4)
        }
        artistNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(albumCoverImage.snp.trailing).offset(8)
            make.top.equalTo(albumNameLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().inset(4)
            make.bottom.equalToSuperview().inset(8)
        }
        
    }
    
    func configure(with track: Track) {
        albumNameLabel.text = track.name
        artistNameLabel.text = track.artists.first?.name ?? ""
        let imageURLString = track.album?.images.first?.url ?? ""
        if let url =  URL(string: imageURLString) {
            albumCoverImage.kf.setImage(with: url)
            albumCoverImage.snp.updateConstraints { make in
                make.height.equalTo(60)
                make.width.equalTo(60)
            }
        }
    }

}
