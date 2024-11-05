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
                            if category != .allMovies {
                                CategoryRow(category: category, valuesProvider: viewModel.getCategoryProvider(for: category))
                                    .environment(viewModel)
                            } else {
                                AllMoviesRow(category: category)
                            }
                        }
                    }
                } else {
                    // Display search results when there's a query
                    
                    ForEach(viewModel.filteredMoviesBySearch) { movie in
                        GroupBox {
                            MovieRow(movie: movie, indentation: 0)
                        }
                    }
                }
            }
            .padding()
            .navigationDestination(for: MovieCategory.self, destination: { category in
                if category == .allMovies {
                    AllMoviesListView()
                }
            })
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .navigationTitle(AppConstants.Strings.appTitle)
            .searchable(text: $viewModel.searchQuery, prompt: AppConstants.Strings.searchBarPlaceholder)
        }
        
    }
    
}

struct AllMoviesRow: View {
    let category: MovieCategory
    
    var body: some View {
        NavigationLink(value: category) {
            GroupBox {
                HStack {
                    Text(category.title)
                        .font(.headline)
                        .foregroundStyle(.black)
                    Spacer()
                    Image(systemName: "chevron.right.circle.fill")
                        .symbolRenderingMode(.hierarchical)
                        .font(.headline)
                        .foregroundStyle(.gray)
                }
                .padding(.vertical, 5)
            }
        }
    }
}

#Preview {
    MovieDatabaseView()
}
