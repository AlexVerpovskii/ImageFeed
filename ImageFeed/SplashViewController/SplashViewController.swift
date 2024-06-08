//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Александр Верповский on 31.05.2024.
//

import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: Lifecycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let token = OAuth2TokenStorage.shared.token
        if token.isEmpty {
            performSegue(withIdentifier: Constants.Identifiers.showAutheSegueIdentifier, sender: nil)
        }
        else {
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

//MARK: Extension SplashViewController, override prepare
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.showAutheSegueIdentifier  {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(Constants.Identifiers.showAutheSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
