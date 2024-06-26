//
//  URLSession+data.swift
//  ImageFeed
//
//  Created by Александр Верповский on 30.05.2024.
//

import Foundation

extension URLSession {
    func data(
        for request: URLRequest,
        completion: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionTask {
        
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data, let response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data))
                } else {
                    fulfillCompletionOnTheMainThread(.failure(Constants.NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(Constants.NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletionOnTheMainThread(.failure(Constants.NetworkError.urlSessionError))
            }
        })
        
        return task
    }
    
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let task = data(for: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let data):
                do {
                    let data = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(data))
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        return task
    }
}
