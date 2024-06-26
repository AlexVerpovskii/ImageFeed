//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Александр Верповский on 30.05.2024.
//

import UIKit
import ProgressHUD

final class AuthViewController: UIViewController {
    
    //MARK: Private UI properties
    @IBOutlet private var enterButtonOutlet: UIButton!
    
    //MARK: Private properties
    private let oAuth2Service = OAuth2Service.shared
    
    //MARK: Public properties
    weak var delegate: AuthViewControllerDelegate?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        enterButtonOutlet.layer.cornerRadius = 16
        configureBackButton()
    }
    
    //MARK: Override prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Identifiers.showWebViewSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController  else { fatalError("Failed to prepare for \(Constants.Identifiers.showWebViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    //MARK: Private methods
    private func configureBackButton() {
        let backButtonImage = UIImage(named: Constants.ImageNames.navBackButton)
        navigationController?.navigationBar.backIndicatorImage = backButtonImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backButtonImage
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func viewErrorAlert() {
        let ac = UIAlertController(title: "Что-то пошло не так(", message: "Не удалось войти в систему", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel)
        ac.addAction(action)
        present(ac, animated: true)
    }
}

//MARK: Extension WebViewViewControllerDelegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            guard let self else { return }
            
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(_):
                delegate?.didAuthenticate(self)
            case .failure(let error):
                print(error)
                viewErrorAlert()
            }
        }
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}
