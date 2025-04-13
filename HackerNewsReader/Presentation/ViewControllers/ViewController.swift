//
//  ViewController.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 02-04-25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    private let getStoriesUseCase = GetStoriesUseCase()
    private let storyListView = StoryListView()
    
    private let filterButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = "Sort"
        config.image = UIImage(systemName: "arrow.up.arrow.down")
        config.imagePlacement = .leading
        config.imagePadding = 6
        
        let button = UIButton(configuration: config)
        button.showsMenuAsPrimaryAction = true
        return button
    }()
    
    private var selectedFilter: StoryType = .latest {
        didSet {
            updateMenu()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Latest stories"
        storyListView.delegate = self
        loadInitialStories(type: .latest)
        layoutListView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: filterButton)
        updateMenu()
    }
    
    private func layoutListView() {
        view.addSubview(storyListView)
        storyListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            storyListView.topAnchor.constraint(equalTo: view.topAnchor),
            storyListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            storyListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            storyListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadInitialStories(type: StoryType) {
        Task {
            do {
                let data = try await getStoriesUseCase.getStories(type: type)
                await MainActor.run {
                    print("data loaded")
                    self.storyListView.update(with: data)
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }
    
    private func loadMoreStoriesIfNeeded() {
        guard !storyListView.isLoading else { return }
        storyListView.showLoadingMore()
        Task {
            do {
                let data = try await getStoriesUseCase.getStories(type: selectedFilter)
                await MainActor.run {
                    print("data loaded")
                    if data.count == 0 {
                        storyListView.showNoMoreData(message: "No more stories")
                        return
                    }
                    self.storyListView.update(with: data, isPaginated: true)
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }
    
    private func refreshStories() {
        Task {
            do {
                let data = try await getStoriesUseCase.getStories(type: selectedFilter, isRefreshing: true)
                await MainActor.run {
                    print("data loaded")
                    if data.count == 0 {
                        storyListView.showNoMoreData(message: "No more stories")
                        return
                    }
                    self.storyListView.didFinishRefreshing()
                    self.storyListView.update(with: data)
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }
    
    private func updateMenu() {
        let actions = StoryType.allCases.map { option in
            UIAction(title: option.rawValue,
                     state: option == selectedFilter ? .on : .off,
                     handler: { [weak self] _ in
                self?.selectedFilter = option
                self?.title = "\(option.rawValue) Stories"
                self?.loadInitialStories(type: option)
            })
        }
        
        filterButton.menu = UIMenu(title: "", children: actions)
    }
    
}

// MARK: - Table View Delegate
extension ViewController: StoryListViewDelegate {
    func didRefreshList() {
        self.refreshStories()
    }
    
    func didSelectStory(_ story: Story) {
        let webVC = WebViewController(story: story)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func didRequestNextPage() {
        loadMoreStoriesIfNeeded()
    }
}
