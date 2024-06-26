//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Александр Верповский on 17.05.2024.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private final let profileService = ProfileService.shared
    private final var profileImageServiceObserver: NSObjectProtocol?
    
    //MARK: Private UI properties
    private lazy var avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.layer.cornerRadius = avatarImage.bounds.width / 2
        if let image = UIImage(named: Constants.ImageNames.avatarPhoto) {
            avatarImage.image = image
        }
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        return avatarImage
    }()
    
    private lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 23)
        nameLabel.textColor = .white
        nameLabel.text = Constants.Other.nameLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nameLabel
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let nicknameLabel = UILabel()
        nicknameLabel.font = UIFont.systemFont(ofSize: 13)
        nicknameLabel.textColor = UIColor(red: 174/255, green: 175/255, blue: 180/255, alpha: 1.0)
        nicknameLabel.text = Constants.Other.nicknameLabel
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        return nicknameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        descriptionLabel.textColor = .white
        descriptionLabel.text = Constants.Other.descriptionLabel
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        return descriptionLabel
    }()
    
    private lazy var exitButton: UIButton = {
        let exitButton = UIButton()
        exitButton.setImage(UIImage(systemName: Constants.ImageNames.exitButtonIcon), for: .normal)
        exitButton.tintColor = .red
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchDown)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        return exitButton
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubview()
        setupConstraint()
        profileImageServiceObserver = NotificationCenter.default.addObserver(
            forName: ProfileImageService.didChangeNotification,
            object: nil,
            queue: .main,
            using: { [weak self] _ in
                guard let self else { return }
                self.updateAvatar()
            })
        updateAvatar()
        guard let profile = profileService.profile else { return }
        updateProfileDetails(profile: profile)
    }
    
    //MARK: Private methods
    @objc
    private func didTapExitButton() {
        print("did tap exit button")
    }
    
    private func updateProfileDetails(profile: Profile) {
        guard let profile = profileService.profile else { return }
        nameLabel.text = profile.name
        nicknameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        let processor = RoundCornerImageProcessor(cornerRadius: 70)
        avatarImage.kf.setImage(with: url, options: [.processor(processor)])
    }
}

//MARK: Setup UI
extension ProfileViewController {
    private func setupSubview() {
        view.addSubview(avatarImage)
        view.addSubview(nameLabel)
        view.addSubview(nicknameLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(exitButton)
    }
    
    private func setupConstraint() {
        NSLayoutConstraint.activate([
            avatarImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 76),
            avatarImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            avatarImage.heightAnchor.constraint(equalToConstant: 70),
            avatarImage.widthAnchor.constraint(equalTo: avatarImage.heightAnchor, multiplier: 1)])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImage.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            nameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            nicknameLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: avatarImage.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            exitButton.heightAnchor.constraint(equalToConstant: 44),
            exitButton.widthAnchor.constraint(equalTo: exitButton.heightAnchor, multiplier: 1),
            exitButton.centerYAnchor.constraint(equalTo: avatarImage.centerYAnchor),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}
