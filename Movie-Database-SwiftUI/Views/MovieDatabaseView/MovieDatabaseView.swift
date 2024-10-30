//
//  MovieDatabaseView.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 27/10/24.
//

import SwiftUI

struct MovieDatabaseView: View {
    @Environment(MovieDatabaseViewModel.self) var viewModel: MovieDatabaseViewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            ScrollView {
                if viewModel.searchQuery.isEmpty {
                    VStack {
                        ForEach(MovieCategory.allCases, id: \.self) { category in
                            CategoryRow(category: category, valuesProvider: viewModel.getCategoryProvider(for: category))
                                .environment(viewModel)
                        }
                    }
                } else {
                    // Display search results when there's a query
                    ForEach(viewModel.filteredMovies) { movie in
                        GroupBox {
                            MovieRow(movie: movie, indentation: 0)
                        }
                    }
                }
            }
            .padding()
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .navigationTitle(AppConstants.Strings.appTitle)
            .searchable(text: $viewModel.searchQuery, prompt: AppConstants.Strings.searchBarPlaceholder)
        }
        
    }
    
}

#Preview {
    MovieDatabaseView()
}
