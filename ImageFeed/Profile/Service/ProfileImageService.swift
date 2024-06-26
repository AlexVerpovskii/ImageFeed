//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Александр Верповский on 26.06.2024.
//

import Foundation

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name("ProfileImageProviderDidChange")
    private init() {}
    
    private (set) var avatarURL: String?
    private var task: URLSessionTask?
    private var username: String?
    
    func fetchProfileImageURL(userName: String, _ completion: @escaping (Result<String?, Error>) -> Void) {
        task?.cancel()
        
        let request = makeUserRequest(userName: userName)
        
        let task = URLSession.shared.objectTask(for: request) { [weak self]  (result: Result<UserResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                avatarURL = data.profileImage?.large
                NotificationCenter.default
                    .post(name: ProfileImageService.didChangeNotification,
                          object: self,
                          userInfo: ["URL": data.profileImage as Any])
                completion(.success(data.profileImage?.large))
            case .failure(let error):
                print("ProfileImageService.fetchProfileImageURL: \(error)")
                completion(.failure(error))
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeUserRequest(userName: String) -> URLRequest {
        guard let token = OAuth2TokenStorage.shared.token else { fatalError() }
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Schema.https
        urlComponents.host = Unsplash.defaultBaseURL
        urlComponents.path = Unsplash.pathUsers + "/" + userName
        
        guard let url = urlComponents.url else { fatalError("invalid url") }
        
        var request = URLRequest(url: url)
        request.setValue(Unsplash.bearer + " " + token, forHTTPHeaderField: Unsplash.authorization)
        request.httpMethod = Constants.HTTPMethod.get
        
        return request
    }
}
