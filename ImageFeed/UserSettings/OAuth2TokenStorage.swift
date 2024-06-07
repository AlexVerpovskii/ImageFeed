//
//  UserSettings.swift
//  ImageFeed
//
//  Created by Александр Верповский on 31.05.2024.
//

import Foundation

typealias Keys = Constants.SettingsKeys
final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let userDefaults = UserDefaults.standard
    
    var token: String {
        get { userDefaults.string(forKey: Keys.token.rawValue) ?? "" }
        set { userDefaults.set(newValue, forKey: Keys.token.rawValue)}
    }
}
