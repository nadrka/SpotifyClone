//
//  UIView.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 30/03/2021.
//

import UIKit

extension UIView {
    
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
    
}
