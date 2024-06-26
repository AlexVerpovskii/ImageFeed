//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Александр Верповский on 30.05.2024.
//


import UIKit
import WebKit

typealias Unsplash = Constants.Unsplash
final class WebViewViewController: UIViewController {
    
    //MARK: Private UI properties
    @IBOutlet private var progressView: UIProgressView!
    @IBOutlet private var webView: WKWebView!
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    //MARK: Public properties
    var delegate: WebViewViewControllerDelegate?
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthView()
        webView.navigationDelegate = self
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self else { return }
                 updateProgress()
             })
    }
    
    //MARK: KVO: override observeValue
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    //MARK: Private methods
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: Constants.Unsplash.unsplashAuthorizeURLString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: Unsplash.clientId, value: Unsplash.accessKey),
            URLQueryItem(name: Unsplash.redirectUriParam, value: Unsplash.redirectURI),
            URLQueryItem(name: Unsplash.responseType, value: Constants.Other.requestCode),
            URLQueryItem(name: Unsplash.scope, value: Unsplash.accessScope)
        ]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == Unsplash.pathAuthorize,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == Constants.Other.requestCode} )
        {
            return codeItem.value
        } else {
            return nil
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
}

//MARK: Extension WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
