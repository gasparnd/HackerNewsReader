//
//  ViewController.swift
//  HackerNewsReader
//
//  Created by Gaspar Dolcemascolo on 02-04-25.
//

import UIKit

class ViewController: UIViewController {
    let getStoriesUseCase = GetStoriesUseCase()
    var stories: [Story] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        loadStories()
        // Do any additional setup after loading the view.
    }

    func loadStories() {
        Task {
            do {
                let data = try await getStoriesUseCase.getStories()
                await MainActor.run {
                    self.stories = data
                }
            } catch {
                print("error, ", error.localizedDescription)
            }
        }
    }

}

