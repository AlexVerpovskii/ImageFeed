//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Александр Верповский on 02.06.2024.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
}
