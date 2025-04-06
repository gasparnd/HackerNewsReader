//
//  ViewController.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 02-04-25.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    private let getStoriesUseCase = GetStoriesUseCase()
    private var stories: [Story] = []
    private let tableView = UITableView()
    private  var footerView: LoadingFooterView!
    private var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        loadInitialStories()
        tableViewSetup()
    }
    
    func loadInitialStories() {
        if stories.count > 0 { return }
        
        Task {
            do {
                let data = try await getStoriesUseCase.getStories()
                await MainActor.run {
                    print("data loaded")
                    self.stories.append(contentsOf: data)
                    print(self.stories.count)
                    isLoading = false
                    self.tableView.reloadData()
                    self.footerView.hide()
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }
    
    func loadMoreStoriesIfNeeded() {
        guard !isLoading else { return }
        isLoading = true
        Task {
            do {
                let data = try await getStoriesUseCase.getStories()
                await MainActor.run {
                    print("data loaded")
                    self.stories.append(contentsOf: data)
                    print(self.stories.count)
                    isLoading = false
                    self.tableView.reloadData()
                    self.footerView.hide()
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }
    
}

// MARK: - Table View Setup
extension ViewController: UITableViewDataSource {
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
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableCellView.reuseID, for: indexPath) as! TableCellView
        let story = self.stories[indexPath.row]
        cell.configure(with: story)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let story = self.stories[indexPath.row]
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
            footerView.showLoading()
            loadMoreStoriesIfNeeded()
        }
    }
}

