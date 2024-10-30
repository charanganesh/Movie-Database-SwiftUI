//
//  AllMoviesList.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 30/10/24.
//

import SwiftUI

struct AllMoviesList: View {
    @Environment(MovieDatabaseViewModel.self) var viewModel: MovieDatabaseViewModel

    var body: some View {
        VStack {
            ForEach(viewModel.movies) { movie in
                Button {
                    // Handle movie selection if needed
                } label: {
                    MovieRow(movie: movie, indentation: 10)
                }
            }
        }
    }
}
