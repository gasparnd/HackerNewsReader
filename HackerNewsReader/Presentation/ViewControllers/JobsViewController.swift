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
    private var jobs: [Story] = []
    private var allJobsFetched: Bool = false
    private let tableView = UITableView()
    private var footerView: LoadingFooterView!
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Jobs"
        loadInitialJobs()
        tableViewSetup()
    }
    
    func loadInitialJobs() {
        Task {
            do {
                let data = try await getStoriesUseCase.getJobs()
                await MainActor.run {
                    print("jobs loaded")
                    self.jobs = data
                    print(self.jobs.count)
                    isLoading = false
                    self.tableView.reloadData()
                    self.footerView.hide()
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }
    
    func loadMoreJobsIfNeeded() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                let data = try await getStoriesUseCase.getJobs()
                await MainActor.run {
                    print("jobs loaded")
                    self.jobs.append(contentsOf: data)
                    print(data.count)
                    isLoading = false
                    self.tableView.reloadData()
                    self.footerView.hide()
                    if data.count == 0 {
                        allJobsFetched = true
                        footerView.showNoMoreData(message: "All jobs loaded")
                    }
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }
    
    
}

// MARK: - Table View Setup
extension JobsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableCellView.self, forCellReuseIdentifier: TableCellView.reuseID)
        footerView = LoadingFooterView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        tableView.tableFooterView = footerView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellView.reuseID, for: indexPath) as! TableCellView
        let story = self.jobs[indexPath.row]
        cell.configure(with: story)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = self.jobs[indexPath.row]
        guard let _ = story.url else { return }
        
        let webVC = WebViewController(story: story)
        navigationController?.pushViewController(webVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height - 100 {
            print("next page")
            if allJobsFetched {
                return
            }
            footerView.showLoading()
            loadMoreJobsIfNeeded()
        }
    }
}

