//
//  UITextField+Combine.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 03/04/2021.
//

import UIKit
import Combine

extension UITextField {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .compactMap(\.text)
            .eraseToAnyPublisher()
    }
    
    var keyBoardDidShowPublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(for: UITextField.keyboardDidShowNotification, object: self)
            .map { _ in return () }
            .eraseToAnyPublisher()
    }
    
    var keyBoardDidHidePublisher: AnyPublisher<Void, Never> {
        NotificationCenter.default.publisher(for: UITextField.keyboardDidHideNotification, object: self)
            .map { _ in return () }
            .eraseToAnyPublisher()
    }
}
