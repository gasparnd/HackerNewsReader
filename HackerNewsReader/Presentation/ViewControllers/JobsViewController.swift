//
//  JobsViewController.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 06-04-25.
//

import Foundation
import UIKit

final class JobsViewController: UIViewController {
    private let getStoriesUseCase = GetStoriesUseCase()
    private let jobListView = StoryListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Jobs"
        jobListView.delegate = self
        layoutListView()
        loadInitialJobs()
    }
    
    private func layoutListView() {
        view.addSubview(jobListView)
        jobListView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jobListView.topAnchor.constraint(equalTo: view.topAnchor),
            jobListView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            jobListView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            jobListView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func loadInitialJobs() {
        Task {
            do {
                let data = try await getStoriesUseCase.getJobs()
                await MainActor.run {
                    print("jobs loaded")
                    jobListView.update(with: data)
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }
    
    func loadMoreJobsIfNeeded() {
        guard !jobListView.isLoading else { return }
        jobListView.showLoadingMore()
        Task {
            do {
                let data = try await getStoriesUseCase.getJobs()
                await MainActor.run {
                    print("jobs loaded")
                    if data.count == 0 {
                        jobListView.showNoMoreData(message: "No more jobs to load")
                        return
                    }
                    jobListView.update(with: data, isPaginated: true)
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }
    
    
}


// MARK: - Table View Delegate
extension JobsViewController: StoryListViewDelegate {
    func didSelectStory(_ story: Story) {
        let webVC = WebViewController(story: story)
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    func didRequestNextPage() {
        loadMoreJobsIfNeeded()
    }
}
