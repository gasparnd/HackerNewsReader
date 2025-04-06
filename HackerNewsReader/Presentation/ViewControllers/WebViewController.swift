//
//  WebViewController.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 06-04-25.
//

import WebKit
import UIKit

final class WebViewController: UIViewController {
    
    private var webView: WKWebView!
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    private let story: Story
    private var isWebLoading: Bool = true
    
    init(story: Story) {
        self.story = story
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        if let url = URL(string: story.url!) {
            activityIndicator.hidesWhenStopped = true
            let barButton = UIBarButtonItem(customView: activityIndicator)
            navigationItem.rightBarButtonItem = barButton
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    func setupLayout() {
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: webView.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator.stopAnimating()
        let saveImage = UIImage(systemName: "bookmark")
        let shareImage = UIImage(systemName: "square.and.arrow.up")
        let saveButton = UIBarButtonItem(image: saveImage, style: .plain, target: self, action: #selector(didTapSave))
        let shareButton = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(didTapShare))
        navigationItem.rightBarButtonItems = [saveButton, shareButton]
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        activityIndicator.stopAnimating()
    }}


// MARK: - ACTIONS

extension WebViewController {
    @objc func didTapSave() {
        
    }
    
    @objc func didTapShare() {
        let textToShare = story.url
        
    }
}

