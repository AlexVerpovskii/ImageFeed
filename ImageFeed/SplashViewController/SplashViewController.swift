//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Александр Верповский on 31.05.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    private final var profileService = ProfileService.shared
    private final let profileImageService = ProfileImageService.shared
    
    private lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: Constants.ImageNames.vector)
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        setupConstraint()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = OAuth2TokenStorage.shared.token
        if token == nil {
            let authViewController = AuthViewController()
            authViewController.delegate = self
            present(authViewController, animated: true)
        }
        else {
            guard let token else { return }
            fetchProfile(token)
            switchToTabBarController()
        }
    }
    
    //MARK: Private methods
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: Constants.Identifiers.mainIdentifier, bundle: .main)
            .instantiateViewController(withIdentifier: Constants.Identifiers.tabBarViewControllerIdentifier)
        
        window.rootViewController = tabBarController
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            
            guard let self = self else { return }
            
            switch result {
            case .success(let profile):
                profileImageService.fetchProfileImageURL(userName: profile.username) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(_):
                        switchToTabBarController()
                    case .failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
                break
            }
        }
        
        
    }
    
}

//MARK: Extension AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        vc.dismiss(animated: true) { [weak self] in
            guard let self else { return }
            self.switchToTabBarController()
        }
    }
}
