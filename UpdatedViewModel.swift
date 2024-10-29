/*
import SwiftUI
import Observation

// MARK: - Protocol Definitions

protocol MovieServiceProtocol {
    func fetchMovies() async throws -> [Movie]
}

protocol MovieDatabaseViewModelProtocol: ObservableObject {
    var movies: [Movie] { get set }
    var searchQuery: String { get set }
    var selectedMovie: Movie? { get set }
    var expandedSection: String? { get set }
    var filteredMovies: [Movie] { get }
    
    func loadMovies() async
    func toggleSection(_ category: String)
}

// MARK: - Movie Service Implementation

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

// MARK: - ViewModel Implementation

@Observable
final class MovieDatabaseViewModel: MovieDatabaseViewModelProtocol {
    // Injected dependency on MovieServiceProtocol
    private let movieService: MovieServiceProtocol
    
    // Public properties
    var movies: [Movie] = []
    var searchQuery: String = ""
    var selectedMovie: Movie?
    var expandedSection: String?
    
    // Computed property for filtered movies
    var filteredMovies: [Movie] {
        guard !searchQuery.isEmpty else { return movies }
        return movies.filter { movie in
            movie.title.contains(searchQuery) ||
            movie.genre.contains(searchQuery) ||
            movie.actors.contains(searchQuery) ||
            movie.director.contains(searchQuery)
        }
    }
    
    // Initializer to inject the dependency
    init(movieService: MovieServiceProtocol = MovieService()) {
        self.movieService = movieService
    }
    
    // Load movies from service
    func loadMovies() async {
        do {
            self.movies = try await movieService.fetchMovies()
        } catch {
            print("Failed to fetch movies: \(error)")
        }
    }
    
    // Toggle section expansion
    func toggleSection(_ category: String) {
        if expandedSection == category {
            expandedSection = nil
        } else {
            expandedSection = category
        }
    }
}
*/
