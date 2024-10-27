//
//  MovieDatabaseViewModel.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 27/10/24.
//

import SwiftUI
import Observation

@Observable
final class MovieDatabaseViewModel {
    var movies: [Movie] = []
    var searchQuery: String = ""
    var filteredMovies: [Movie] = []
    var selectedMovie: Movie?
    var expandedSection: String? // Track expanded section
    var expandedSubCategory: String? // Track expanded sub-category
    
    func loadMovies() {
        // Attempt to locate the file in the bundle
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            print("Error: movies.json file not found in bundle.")
            return
        }
        
        do {
            // Load data from file URL
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            // Attempt to decode the data into Movie objects
            let decodedMovies = try decoder.decode([Movie].self, from: data)
            DispatchQueue.main.async {
                self.movies = decodedMovies
                self.filteredMovies = self.movies
            }
        } catch {
            // Print decoding error for debugging
            print("Error loading or decoding movies.json: \(error)")
        }
    }
    
    func filterMovies(by query: String) {
        if query.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = movies.filter {
                $0.title.contains(query) || $0.genre.contains(query) || $0.actors.contains(query) || $0.director.contains(query)
            }
        }
    }
    
    func toggleSection(_ category: String) {
        if expandedSection == category {
            // If already expanded, collapse it and reset subcategory
            expandedSection = nil
            expandedSubCategory = nil
        } else {
            // Expand this category and reset the subcategory
            expandedSection = category
            expandedSubCategory = nil
        }
    }
    
    func toggleSubCategory(_ subCategory: String) {
        if expandedSubCategory == subCategory {
            expandedSubCategory = nil
        } else {
            expandedSubCategory = subCategory
        }
    }
}
