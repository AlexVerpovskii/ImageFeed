//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Александр Верповский on 30.05.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private init() {}
    
    func fetchOAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        let request = makeOAuthTokenRequest(code: code)
        URLSession.shared.data(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let token = try JSONDecoder().decode(OAuthTokenResponseBody.self, from: data)
                    OAuth2TokenStorage.shared.token = token.accessToken
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Schema.https
        urlComponents.host = Unsplash.host
        urlComponents.path = Unsplash.path
        
        urlComponents.queryItems = [
            URLQueryItem(name: Unsplash.clientId, value: Unsplash.accessKey),
            URLQueryItem(name: Unsplash.clientSecret, value: Unsplash.secretKey),
            URLQueryItem(name: Unsplash.redirectUriParam, value: Unsplash.redirectURI),
            URLQueryItem(name: Constants.Other.requestCode, value: code),
            URLQueryItem(name: Unsplash.grantType, value: Unsplash.authorizationCode)
        ]
        
        guard let url = urlComponents.url else { fatalError("invalid url") }
        
        var request = URLRequest(url: url)
        request.httpMethod = Constants.HTTPMethod.post
        
        return request
    }
}
