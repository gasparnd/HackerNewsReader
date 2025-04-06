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
    private let story: Story
    
    init(story: Story) {
        self.story = story
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string: story.url!) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
