//
//  MovieListViewModel.swift
//  Movie Database
//
//  Created by Charan Ganesh on 26/10/24.
//

import Foundation
import UIKit


extension String: @retroactive Error {}

protocol MovieFetcherProtocol {
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
}

struct MovieService: MovieFetcherProtocol {
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Locate the local JSON file
            guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
                print("movies.json file not found")
                DispatchQueue.main.async { completion(.failure("movies.json file not found")) }
                return
            }
            
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let movies = try decoder.decode([Movie].self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(movies))
                }
                
            } catch {
                completion(.failure(error))
            }
        }
    }
}

final class MovieDatabaseViewModel: TableViewModelProtocol, ObservableObject {
    
    private var movies: [Movie] = []
    private(set) var filteredMovies: [Movie] = []
    var isSearching: Bool = false
    var selectedCategory: String?
    var expandedCategorySelections: [String: (value: String?, index: Int?)] = [:]
    private let movieService: MovieFetcherProtocol
    
    // MARK: - Expand State Tracking Properties
    private var isYearExpanded: Bool = false
    private var isGenreExpanded: Bool = false
    private var isDirectorExpanded: Bool = false
    private var isActorExpanded: Bool = false
    private var isAllMoviesExpanded: Bool = false
    
    var reloadData: (() -> Void) = {
        fatalError("reloadData must be overridden")
    }
    var onTapMovie: ((Movie) -> Void) = { _ in
        fatalError("onTapMovie must be overridden")
    }
    
    init(movieService: MovieFetcherProtocol) {
        self.movieService = movieService
    }
    
    var registerableCells: [any RegisterableTableViewCellProtocol.Type] {
        [MovieTableViewCell.self, CategoryTableViewCell.self]
    }
    
    func fetchMovies() {
        movieService.fetchMovies { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movies):
                DispatchQueue.main.async {
                    self.movies = movies
                    self.filteredMovies = movies
                    self.reloadData()
                }
            case .failure:
                break
            }
        }
    }
    
    // Filter movies based on search text
    func filterMovies(with query: String) {
        isSearching = !query.isEmpty
        if isSearching {
            filteredMovies = movies.filter { movie in
                movie.title.localizedCaseInsensitiveContains(query) ||
                movie.genre.localizedCaseInsensitiveContains(query) ||
                movie.actors.localizedCaseInsensitiveContains(query) ||
                movie.director.localizedCaseInsensitiveContains(query)
            }
        } else {
            filteredMovies = []
        }
        reloadData() // Refresh UI
    }

    // Reset search state when cancelling search
    func cancelSearch() {
        isSearching = false
        filteredMovies = []
        reloadData()
    }

}

extension MovieDatabaseViewModel {
    
    var sections: [TableViewSection] {
        if isSearching {
            // Display only movies when searching
            return [filteredMoviesSection]
        } else {
            return [
                yearSection,
                genreSection,
                directorSection,
                actorSection,
                allMoviesSection
            ]
        }
    }
    var genreSection: TableViewSection {
        createSection(for: "Genre") { movie in
            Array(Set(movie.genre.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }))
        }
    }
    
    // Section for Actor
    var actorSection: TableViewSection {
        createSection(for: "Actor") { movie in
            movie.actors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        }
    }
    
    // Section for Director
    var directorSection: TableViewSection {
        createSection(for: "Director") { movie in
            [movie.director]
        }
    }
    
    // Section for Year
    var yearSection: TableViewSection {
        createSection(for: "Year") { movie in
            [movie.year]
        }
    }
    
    private func createSection(for category: String, valuesProvider: (Movie) -> [String]) -> TableViewSection {
        var cells: [any TableViewCellViewModelProtocol]
        
        let mainCellViewModel = CategoryCellViewModel(categoryName: category)
        mainCellViewModel.onTap = { [weak self] in
            guard let self = self else { return }
            
            // Toggle the main category expansion
            if self.selectedCategory == category {
                self.selectedCategory = nil
                self.expandedCategorySelections[category] = (nil, nil)
            } else {
                self.selectedCategory = category
                self.expandedCategorySelections[category] = (nil, nil) // Reset any previous selection
            }
            self.reloadData()
        }
        
        cells = [mainCellViewModel]
        
        // Second level: Expand the category list if the main category is selected
        if selectedCategory == category {
            let uniqueValues = Array(Set(movies.flatMap(valuesProvider))).sorted()
            
            let valueCells = uniqueValues.enumerated().map { index, value in
                let valueCell = CategoryCellViewModel(categoryName: value, indentationLevel: 1)
                
                valueCell.onTap = { [weak self] in
                    guard let self = self else { return }
                    
                    // Toggle the selection for the value under the current category
                    if self.expandedCategorySelections[category]?.value == value {
                        self.expandedCategorySelections[category] = (nil, nil)
                    } else {
                        self.expandedCategorySelections[category] = (value, index)
                    }
                    
                    self.reloadData()
                }
                
                return valueCell
            }
            
            cells += valueCells
            
            // Third level: Show movies under the selected value within the category
            if let selectedValue = expandedCategorySelections[category]?.value,
               let selectedIndex = expandedCategorySelections[category]?.index {
                
                let movieCells = movies
                    .filter { valuesProvider($0).contains(selectedValue) }
                    .map { movie in
                        let movieCell = MovieCellViewModel(
                            title: movie.title,
                            year: movie.year,
                            language: movie.language,
                            thumbnailURL: URL(string: movie.poster),
                            indentationLevel: 2
                        )
                        movieCell.onTap = { [weak self] in
                            self?.onTapMovie(movie)
                        }
                        return movieCell
                    }
                
                // Insert movie cells immediately after the selected value cell
                cells.insert(contentsOf: movieCells, at: selectedIndex + 2) // Offset for main cell and 0-based index
            }
        }
        
        return TableViewSection(title: nil, items: cells)
    }
        
    // MARK: - All Movies Section
    var allMoviesSection: TableViewSection {
        let cells: [any TableViewCellViewModelProtocol]
        
        // Define the main "All Movies" category cell with onTap to expand/collapse
        let allMoviesCellViewModel = CategoryCellViewModel(categoryName: "All Movies")
        allMoviesCellViewModel.onTap = { [weak self] in
            guard let self = self else { return }
            self.isAllMoviesExpanded.toggle()
            self.reloadData()
        }
        
        // Map each movie to a MovieCellViewModel and set its onTap closure
        let movieCells = movies.map { movie in
            let movieCellViewModel = MovieCellViewModel(
                title: movie.title,
                year: movie.year,
                language: movie.language,
                thumbnailURL: URL(string: movie.poster),
                indentationLevel: 1
            )
            
            // Set the onTap closure to notify the ViewModel when a movie is selected
            movieCellViewModel.onTap = { [weak self] in
                self?.onTapMovie(movie)
            }
            
            return movieCellViewModel
        }
        
        // Expand or collapse based on the isAllMoviesExpanded flag
        cells = isAllMoviesExpanded ? [allMoviesCellViewModel] + movieCells : [allMoviesCellViewModel]
        
        return TableViewSection(title: nil, items: cells)
    }
    
    // Section displaying filtered movies when in search mode
    private var filteredMoviesSection: TableViewSection {
        let movieCells = filteredMovies.map { movie in
            let movieCellViewModel = MovieCellViewModel(
                title: movie.title,
                year: movie.year,
                language: movie.language,
                thumbnailURL: URL(string: movie.poster)
            )
            movieCellViewModel.onTap = { [weak self] in
                self?.onTapMovie(movie)
            }
            return movieCellViewModel
        }
        return TableViewSection(title: "\(movieCells.count) Search Results", items: movieCells)
    }

}
