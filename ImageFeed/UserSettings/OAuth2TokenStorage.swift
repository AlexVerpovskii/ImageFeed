//
//  UserSettings.swift
//  ImageFeed
//
//  Created by Александр Верповский on 31.05.2024.
//

import Foundation
import SwiftKeychainWrapper

typealias Keys = Constants.SettingsKeys

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private init() {}
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            if let value = newValue {
                KeychainWrapper.standard.set(value, forKey: Keys.token.rawValue)
            } else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
            }
        }
    }
    
    func removeAllKeys() {
        KeychainWrapper.standard.removeAllKeys()
    }
}
