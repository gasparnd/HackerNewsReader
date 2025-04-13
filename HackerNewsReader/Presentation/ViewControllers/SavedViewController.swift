//
//  SavedViewController.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 06-04-25.
//

import Foundation
import UIKit

final class SavedViewController: UIViewController {
    private let useCases = GetStoriesUseCase()
    private let savedStoryList = StoryListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savedStoryList.delegate = self
        setupList()
        loadSavedStories()
    }
    
    private func loadSavedStories() {
        print("starts")
        Task {
            do {
                let data = useCases.getSavedStories()
                savedStoryList.update(with: data)
            }
        }
    }
    
    private func refreshSavedStories() {
        print("starts")
        Task {
            do {
                let data = useCases.getSavedStories()
                savedStoryList.didFinishRefreshing()
                savedStoryList.update(with: data)
            }
        }
    }
    
    private func setupList() {
        view.addSubview(savedStoryList)
        savedStoryList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            savedStoryList.topAnchor.constraint(equalTo: view.topAnchor),
            savedStoryList.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            savedStoryList.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            savedStoryList.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - TABLE VIEW DELEGATE

extension SavedViewController: StoryListViewDelegate {
    func didRefreshList() {
        self.refreshSavedStories()
    }
    
    func didSelectStory(_ story: Story) {
        let webVC = WebViewController(story: story)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func didRequestNextPage() {
        savedStoryList.showNoMoreData(message: "No more saved data")
    }
    
    
}
