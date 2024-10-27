//
//  MovieDetailViewModel.swift
//  Movie Database
//
//  Created by Charan Ganesh on 27/10/24.
//

import Foundation
import UIKit

final class MovieDetailViewModel {

    private let movie: Movie
    private(set) var sections: [TableViewSection] = []

    init(movie: Movie) {
        self.movie = movie
        configureSections()
    }

    private func configureSections() {
        let ratingsData = movie.ratings.map { ($0.source.rawValue, $0.value) }
        let headerCellViewModel = MovieDetailHeaderCellViewModel(
            title: movie.title,
            year: movie.year,
            genres: movie.genre,
            language: movie.language,
            thumbnailURL: URL(string: movie.poster),
            ratings: ratingsData
        )
        
        let castAndCrewCellViewModel = MovieDetailDataCellViewModel(
            title: "Cast & Crew",
            data: movie.actors
        )
        
        let plotCellViewModel = MovieDetailDataCellViewModel(
            title: "Plot",
            data: movie.plot
        )
        
        sections = [
            TableViewSection(title: nil, items: [headerCellViewModel, castAndCrewCellViewModel, plotCellViewModel])
        ]
    }

    func registerCells(for tableView: UITableView) {
        tableView.register(UINib(nibName: "MovieDetailHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailHeaderTableViewCell")
        tableView.register(UINib(nibName: "MovieDetailDataTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailDataTableViewCell")
        // Add other cells as needed here, e.g., if you add CategoryTableViewCell or MovieTableViewCell later
    }

    func numberOfSections() -> Int {
        return sections.count
    }

    func numberOfRows(in section: Int) -> Int {
        return sections[section].items.count
    }
}
