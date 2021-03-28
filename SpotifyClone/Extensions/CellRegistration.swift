//
//  CellRegistration.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 25/03/2021.
//

import UIKit

extension UICollectionView.CellRegistration {
    var cellProvider: (UICollectionView, IndexPath, Item) -> Cell {
        return  { collectionView, indexPath, item in
            collectionView.dequeueConfiguredReusableCell(
                using: self,
                for: indexPath,
                item: item
            )
        }
    }
}
