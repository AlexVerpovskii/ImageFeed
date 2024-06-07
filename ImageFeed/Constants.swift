//
//  Constants.swift
//  ImageFeed
//
//  Created by Александр Верповский on 03.05.2024.
//

import Foundation

enum Constants {
    
    enum SettingsKeys: String {
        case token
    }
    
    enum ImageNames {
        static let LikeOn = "like_on"
        static let LikeOff = "like_off"
        static let avatarPhoto = "Photo"
        static let exitButtonIcon = "ipad.and.arrow.forward"
        static let navBackButton = "nav_back_button"
    }
    
    enum Identifiers {
        static let reuseIdentifier = "ImagesListCell"
        static let showSingleImageSegueIdentifier = "ShowSingleImage"
        static let showWebViewSegueIdentifier = "ShowWebView"
        static let showAutheSegueIdentifier = "showAutheSegueIdentifier"
        static let tabBarViewControllerIdentifier = "TabBarViewController"
        static let mainIdentifier = "Main"
    }
    enum Other {
        static let dateFormat = "dd MMMM yyyy"
        static let formatterLocal = "ru_RU"
        static let nameLabel = "Екатерина Новикова"
        static let nicknameLabel = "@Ekaterina_vov"
        static let descriptionLabel = "Hello, world!"
        static let requestCode = "code"
    }
    
    enum Unsplash {
        static let accessKey = "iYvSt9RTk4aHHX2aFooC9DdE2L_AyIxEaNi4IGP8PlY"
        static let secretKey = "hRkIvS8mskQ7NsdRM6VaQoqmWSoUW1fsvCsOTtA5RLs"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let authorizationCode = "authorization_code"
        static let defaultBaseURL = URL(string: "https://api.unsplash.com")!
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let clientId = "client_id"
        static let clientSecret = "client_secret"
        static let redirectUriParam = "redirect_uri"
        static let responseType = "response_type"
        static let grantType = "grant_type"
        static let scope = "scope"
        static let host = "unsplash.com"
        static let path = "/oauth/token"
    }
    
    enum HTTPMethod {
        static let post = "POST"
        static let get = "GET"
    }
    
    enum Schema {
        static let http = "http"
        static let https = "https"
    }
    
    enum NetworkError: Error {
        case httpStatusCode(Int)
        case urlRequestError(Error)
        case urlSessionError
    }
}
