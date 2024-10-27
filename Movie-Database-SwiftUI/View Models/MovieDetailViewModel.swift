//
//  MovieDetailViewModel.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 28/10/24.
//

import SwiftUI
import Observation

@Observable
class MovieDetailViewModel {
    let movie: Movie
    var selectedRatingSource: String?
    
    var availableRatings: [(source: String, value: String)] {
        movie.ratings.map { ($0.source, $0.value) }
    }
    
    var selectedRatingValue: String? {
        guard let source = selectedRatingSource else { return nil }
        return availableRatings.first { $0.source == source }?.value
    }
    
    init(movie: Movie) {
        self.movie = movie
        selectedRatingSource = availableRatings.first?.source
    }
}
