//
//  MovieDatabaseViewModel.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 27/10/24.
//

import SwiftUI
import Observation

protocol MovieServiceProtocol {
    func fetchMovies() async throws -> [Movie]
}

final class MovieService: MovieServiceProtocol {
    func fetchMovies() async throws -> [Movie] {
        guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
            throw NSError(domain: "", code: 404, userInfo: [NSLocalizedDescriptionKey: "movies.json file not found in bundle."])
        }
        
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        return try decoder.decode([Movie].self, from: data)
    }
}

@Observable
final class MovieDatabaseViewModel {
    var movies: [Movie] = []
    var searchQuery: String = ""
    var expandedSection: MovieCategory?
    var selectedFilterOption: FilterOptions?
    
    private let movieService: MovieServiceProtocol
    
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }
    
    var filteredMoviesBySearch: [Movie] {
        guard !searchQuery.isEmpty else { return movies }
        return movies.filter {
            $0.title.contains(searchQuery) || $0.genre.contains(searchQuery) || $0.actors.contains(searchQuery) || $0.director.contains(searchQuery)
        }
    }
    
    var filteredMovies: [Movie] {
        switch selectedFilterOption {
        case .ascending:
            return movies.sorted { $0.title < $1.title}
        case .descending:
            return movies.sorted { $0.title > $1.title}
        case .year:
            return movies.sorted { $0.year < $1.year }
        case .none:
            return movies
        }
    }
    
    func loadMovies() async {
        do {
            self.movies = try await movieService.fetchMovies()
        } catch {
            print("Failed to fetch movies: \(error)")
        }
    }
    func toggleSection(_ category: MovieCategory) {
        if expandedSection == category {
            expandedSection = nil
        } else {
            expandedSection = category
        }
    }
    func getCategoryProvider(for category: MovieCategory) -> (Movie) -> [String] {
        switch category {
        case .year:
            return { [$0.year] }
        case .genre:
            return { $0.genre.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
        case .directors:
            return { [$0.director] }
        case .actors:
            return { $0.actors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
        case .allMovies:
            return { _ in [] }
        }
    }
}
