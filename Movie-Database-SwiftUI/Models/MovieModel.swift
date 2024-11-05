//
//  MovieModel.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 27/10/24.
//

import Foundation

// MARK: - Movie
struct Movie: Codable, Identifiable, Hashable {
    var id = UUID()
    let title, year, rated, released: String
    let runtime, genre, director, writer: String
    let actors, plot, language, country: String
    let awards: String
    let poster: String
    let ratings: [Rating]
    let metascore, imdbRating, imdbVotes, imdbID: String
    let type: TypeEnum
    let dvd: String?
    let boxOffice, production: String?
    let website: String?
    let response: String
    let totalSeasons: String?

    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case rated = "Rated"
        case released = "Released"
        case runtime = "Runtime"
        case genre = "Genre"
        case director = "Director"
        case writer = "Writer"
        case actors = "Actors"
        case plot = "Plot"
        case language = "Language"
        case country = "Country"
        case awards = "Awards"
        case poster = "Poster"
        case ratings = "Ratings"
        case metascore = "Metascore"
        case imdbRating, imdbVotes, imdbID
        case type = "Type"
        case dvd = "DVD"
        case boxOffice = "BoxOffice"
        case production = "Production"
        case website = "Website"
        case response = "Response"
        case totalSeasons
    }
}


// MARK: - Rating
struct Rating: Codable, Hashable {
    let source: String
    let value: String

    enum CodingKeys: String, CodingKey {
        case source = "Source"
        case value = "Value"
    }
}

enum TypeEnum: String, Codable {
    case movie = "movie"
    case series = "series"
}

typealias Movies = [Movie]

enum MovieCategory: CaseIterable, Hashable {
    case year
    case genre
    case directors
    case actors
    case allMovies

    var title: String {
        switch self {
        case .year:
            return "Year"
        case .genre:
            return "Genre"
        case .directors:
            return "Directors"
        case .actors:
            return "Actors"
        case .allMovies:
            return "All Movies"
        }
    }
}

enum FilterOptions: CaseIterable {
    case ascending, descending, year
    
    var title: String {
        switch self {
        case .ascending: return "Ascending"
        case .descending: return "Descending"
        case .year: return "Year"
        }
    }
}
