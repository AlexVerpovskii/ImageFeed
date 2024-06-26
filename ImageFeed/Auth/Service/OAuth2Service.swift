//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Александр Верповский on 30.05.2024.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private init() {}
    
func fetchOAuthToken(code: String, completion: @escaping (Swift.Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard lastCode != code
        else {
            completion(.failure(Constants.AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastCode = code
        
        let request = makeOAuthTokenRequest(code: code)
    
        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
            switch result {
            case .success(let data):
                OAuth2TokenStorage.shared.token = data.accessToken
                self?.task = nil
                self?.lastCode = nil
                completion(.success(data.accessToken))
            case .failure(let error):
                print("OAuth2Service.fetchOAuthToken: \(error)")
                completion(.failure(error
                                   ))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeOAuthTokenRequest(code: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Schema.https
        urlComponents.host = Unsplash.host
        urlComponents.path = Unsplash.pathToken
        
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
