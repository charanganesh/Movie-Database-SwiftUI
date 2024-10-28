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
    var selectedMovie: Movie?
    var expandedSection: String?
    var expandedSubCategory: String?
    
    var filteredMovies: [Movie] {
        guard !searchQuery.isEmpty else { return movies }
        return movies.filter {
            $0.title.contains(searchQuery) || $0.genre.contains(searchQuery) || $0.actors.contains(searchQuery) || $0.director.contains(searchQuery)
        }
    }
    
    func loadMovies() {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            print("Error: movies.json file not found in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            
            let decodedMovies = try decoder.decode([Movie].self, from: data)
            DispatchQueue.main.async {
                self.movies = decodedMovies
            }
        } catch {
            print("Error loading or decoding movies.json: \(error)")
        }
    }


    
    func toggleSection(_ category: String) {
        if expandedSection == category {
            expandedSection = nil
            expandedSubCategory = nil
        } else {
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
