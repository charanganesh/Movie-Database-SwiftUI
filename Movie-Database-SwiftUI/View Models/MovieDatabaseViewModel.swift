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
    
    var filteredMovies: [Movie] {
        guard !searchQuery.isEmpty else { return movies }
        return movies.filter {
            $0.title.contains(searchQuery) || $0.genre.contains(searchQuery) || $0.actors.contains(searchQuery) || $0.director.contains(searchQuery)
        }
    }
    
    func fetchMovies() async throws -> [Movie] {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "movies.json file not found in bundle."])
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let movies = try decoder.decode([Movie].self, from: data)
        
        return movies
    }
    
    func toggleSection(_ category: String) {
        if expandedSection == category {
            expandedSection = nil
        } else {
            expandedSection = category
        }
    }
}
