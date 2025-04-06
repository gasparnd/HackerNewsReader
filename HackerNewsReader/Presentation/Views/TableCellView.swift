//
//  TableCellView.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 06-04-25.
//

import Foundation
import UIKit

final class TableCellView: UITableViewCell {
    
    static let reuseID = "StoryCell"
    
    let profileImageView = UIImageView()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    let urlLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    let authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    let timeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .preferredFont(forTextStyle: .footnote)
        return label
    }()
    
    let nameLabel = UILabel()
    let phoneLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension TableCellView {
    private func setupUI() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        urlLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(urlLabel)
        
        pointsLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(pointsLabel)
        
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(authorLabel)
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 3),
            contentView.trailingAnchor.constraint(equalToSystemSpacingAfter: titleLabel.trailingAnchor, multiplier: 2),
            
            urlLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 3),
            urlLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            authorLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
            authorLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: contentView.leadingAnchor, multiplier: 3),
            
            pointsLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
            pointsLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: authorLabel.trailingAnchor, multiplier: 3),
            
            timeLabel.topAnchor.constraint(equalTo: urlLabel.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: pointsLabel.trailingAnchor, multiplier: 3),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with story: Story) {
        titleLabel.text = story.title
        urlLabel.text = extractDomain(from: story.url)
        pointsLabel.text = "points: 0"
        authorLabel.text = "by \(story.by ?? "Anonymous")"
        
        let timestamp: TimeInterval = TimeInterval(story.time)
        let time = timeAgo(from: timestamp)
        timeLabel.text = time
    }
}
