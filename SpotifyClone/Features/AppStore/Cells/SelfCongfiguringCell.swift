//
//  SelfCongfiguringCell.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 18/03/2021.
//

import Foundation

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with app: App)
}
