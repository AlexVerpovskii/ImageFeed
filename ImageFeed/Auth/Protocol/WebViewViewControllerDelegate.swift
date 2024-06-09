//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Александр Верповский on 30.05.2024.
//

import Foundation

protocol WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
