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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        loadStories()
        tableViewSetup()
    }
    
    func loadStories() {
        Task {
            do {
                let data = try await getStoriesUseCase.getStories()
                await MainActor.run {
                    print("data loaded")
                    self.stories = data
                    print(self.stories.count)
                    self.tableView.reloadData()
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableViewSetup() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableCellView.self, forCellReuseIdentifier: TableCellView.reuseID)
        
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
}

