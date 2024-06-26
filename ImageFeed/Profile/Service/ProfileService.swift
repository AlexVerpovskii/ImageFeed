//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Александр Верповский on 25.06.2024.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile?
    
    private var task: URLSessionTask?
    private var lastToken: String?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        guard lastToken != token
        else {
            completion(.failure(Constants.AuthServiceError.invalidRequest))
            return
        }
        
        task?.cancel()
        lastToken = token
        
        let request = makeProfileRequest(token: token)

        let task = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self else { return }
            switch result {
            case .success(let data):
                profile = converter(profileResult: data)
                completion(.success(converter(profileResult: data)))
                self.task = nil
                self.lastToken = nil
            case .failure(let error):
                print("ProfileService.fetchProfile: \(error)")
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeProfileRequest(token: String) -> URLRequest {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.Schema.https
        urlComponents.host = Unsplash.defaultBaseURL
        urlComponents.path = Unsplash.pathProfile
        
        guard let url = urlComponents.url else { fatalError("invalid url") }
        
        var request = URLRequest(url: url)
        request.setValue(Unsplash.bearer + " " + token, forHTTPHeaderField: Unsplash.authorization)
        request.httpMethod = Constants.HTTPMethod.get
        
        return request
    }
    
    private func converter(profileResult: ProfileResult) -> Profile {
        let name = "\(profileResult.firstName) \(profileResult.lastName)"
        return Profile(
            username: profileResult.username,
            name: name,
            loginName: "@ \(profileResult.username)",
            bio: profileResult.bio ?? ""
        )
    }
}
