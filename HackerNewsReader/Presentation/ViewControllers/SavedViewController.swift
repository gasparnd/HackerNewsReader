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
    private var stories: [Story] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        loadSavedStories()
    }
    
    func loadSavedStories() {
        print("starts")
        Task {
            do {
                let data = useCases.getSavedStories()
                print(stories)
                stories = data
            }
        }
        
    }
}
