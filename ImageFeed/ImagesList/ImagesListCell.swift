//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Александр Верповский on 03.05.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Static Properties
    static let reuseIdentifier = Constants.Other.reuseIdentifier
    
    // MARK: - IB Outlets
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imageCard: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCard.layer.cornerRadius = 16
        imageCard.layer.masksToBounds = true
        dateLabel.font = UIFont.systemFont(ofSize: 13)
        dateLabel.textColor = .white
        setupGradient()
    }
    
    // MARK: - Private Methods
    private func setupGradient() {
        gradientView.backgroundColor = .clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        let startColor = UIColor(named: Constants.ColorNames.YPGradientStart) ?? UIColor.clear
        let endColor = UIColor(named: Constants.ColorNames.YPGradientEnd) ?? UIColor.clear
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
    }
    
}
