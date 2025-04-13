//
//  StoriesListView.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 13-04-25.
//

import Foundation
import UIKit

protocol StoryListViewDelegate: AnyObject {
    func didSelectStory(_ story: Story)
    func didRequestNextPage()
    func didRefreshList()
}

final class StoryListView: UIView {
    
    weak var delegate: StoryListViewDelegate?
    
    private var stories: [Story] = []
    private var isLoadingMore = false
    private var allDataFetchCompleted = false
    private var footerView: LoadingFooterView!
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTable()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTable()
    }
    
    private func setupTable() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
        
        tableView.register(TableCellView.self, forCellReuseIdentifier: TableCellView.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        footerView = LoadingFooterView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 80))
        tableView.tableFooterView = footerView
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    @objc private func handleRefresh() {
        delegate?.didRefreshList()
    }
    
    func didFinishRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func update(with stories: [Story], isPaginated: Bool = false) {
        if isPaginated {
            self.stories.append(contentsOf: stories)
        } else {
            self.stories = stories
        }
        isLoadingMore = false
        footerView.hide()
        tableView.reloadData()
    }
    
    func showLoadingMore() {
        isLoadingMore = true
        footerView.showLoading()
    }
    
    var isLoading: Bool {
        return isLoadingMore
    }
    
    func showNoMoreData(message: String) {
        allDataFetchCompleted = true
        isLoadingMore = false
        footerView.showNoMoreData(message: message)
    }
}

extension StoryListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellView.reuseID, for: indexPath) as! TableCellView
        cell.configure(with: stories[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = stories[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectStory(story)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isLoading else { return }
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            guard !allDataFetchCompleted else {
                return
            }
            footerView.showLoading()
            delegate?.didRequestNextPage()
        }
    }
}
