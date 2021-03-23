//
//  UserDefaultsManager.swift
//  SpotifyClone
//
//  Created by karol.nadratowski on 15/03/2021.
//

import Foundation

struct UserDefaultsManager {
    @UserDefaultValue(key: "accessToken", defaultValue: nil)
    static var accessToken: String?
    
    @UserDefaultValue(key: "refreshToken", defaultValue: nil)
    static var refreshToken: String?
    
    @UserDefaultValue(key: "expirationDate", defaultValue: nil)
    static var expirationDate: Date?
}


@propertyWrapper
struct UserDefaultValue<Value> {
    let key: String
    let defaultValue: Value

    init(key: String, defaultValue: Value) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: Value {
        get {
            (UserDefaults.standard.object(forKey: key) as? Value) ?? defaultValue
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: key)
        }
    }
    
    var projectedValue: Self {
        get {
            return self
        }
    }
    
    func removeValue() {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
}
