//
//  LoadingFooterView.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 06-04-25.
//

import UIKit

final class LoadingFooterView: UIView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let messageLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(activityIndicator)
        addSubview(messageLabel)
        
        messageLabel.text = "Not more stories"
        messageLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        messageLabel.textAlignment = .center
        messageLabel.isHidden = true
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10),
        ])
    }
    
    
    
    func showLoading() {
        activityIndicator.startAnimating()
        messageLabel.isHidden = true
    }
    
    func showNoMoreData(message: String?) {
        if let message = message {
            messageLabel.text = message
        }
        activityIndicator.stopAnimating()
        messageLabel.isHidden = false
    }
    
    func hide() {
        activityIndicator.stopAnimating()
        messageLabel.isHidden = true
    }
}



