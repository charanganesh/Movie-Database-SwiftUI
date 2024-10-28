//
//  MovieDatabaseView.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 27/10/24.
//

import SwiftUI

struct MovieDatabaseView: View {
    @State private var viewModel = MovieDatabaseViewModel()
    @State private var selectedMovie: Movie? = nil // for navigation

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if viewModel.searchQuery.isEmpty {
                    
                        categoryRow(category: "Year") { [$0.year] }
                        categoryRow(category: "Genre") { $0.genre.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
                        categoryRow(category: "Directors") { [$0.director] }
                        categoryRow(category: "Actors") { $0.actors.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) } }
                        categoryRow(category: "All Movies") { _ in [] }
                        
                    } else {
                        // Display search results when there's a query
                        ForEach(viewModel.filteredMovies) { movie in
                            GroupBox {
                                Button {
                                    selectedMovie = movie
                                } label: {
                                    movieRow(movie, indentation: 0)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
            .navigationTitle("Movie Database")
            .searchable(text: $viewModel.searchQuery, prompt: "Search movies by title, genre, actor, director")
            .task {
                await loadMovies()
            }

        }
    }
    
    // MARK: Category Cell
    
    // category is the title label
    // valuesProvider is used to provide the values for the category
    private func categoryRow(category: String, valuesProvider: @escaping (Movie) -> [String]) -> some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 4) {
                Button(action: {
                    withAnimation {
                        viewModel.toggleSection(category)
                    }
                }) {
                    HStack {
                        Text(category)
                            .font(.headline)
                            .foregroundStyle(.black)
                        Spacer()
                        Image(systemName: viewModel.expandedSection == category ? "chevron.down.circle.fill" : "chevron.right.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.headline)
                            .foregroundStyle(viewModel.expandedSection == category ? .green : .secondary)
                    }
                    .padding(.vertical, 5)
                }

                if viewModel.expandedSection == category {
                    if category.lowercased() == "all movies" {
                        GroupBox {
                            ForEach(viewModel.movies) { movie in
                                Button {
                                    selectedMovie = movie
                                } label: {
                                    movieRow(movie, indentation: 10)
                                }
                            }
                        }
                    } else {
                        GroupBox {
                            expandableCategoryList(items: Array(Set(viewModel.movies.flatMap(valuesProvider)).sorted()), filterBy: valuesProvider)
                        }
                    }
                }
            }
        }

    }
    
    // MARK: Movie Cell
    private func movieRow(_ movie: Movie, indentation: CGFloat = 0) -> some View {
        NavigationLink(value: movie) {
            HStack {
                AsyncImage(url: URL(string: movie.poster)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 70)
                } placeholder: {
                    Image("movie-poster-placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 70)
                }
                
                VStack(alignment: .leading) {
                    Text(movie.title)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                    Text("\(movie.year) | \(movie.language)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.leading, indentation)

        }
    }

    private func expandableCategoryList(items: [String], filterBy: @escaping (Movie) -> [String]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                DisclosureGroup("\(item)") {
                    ForEach(viewModel.movies.filter { filterBy($0).contains(item) }) { movie in
                        movieRow(movie, indentation: 20)
                    }
                }
                .tint(.black)

            }
        }
    }
    private func loadMovies() async {
        do {
            viewModel.movies = try await viewModel.fetchMovies()
        } catch {
            print("Error loading movies: \(error)")
        }
    }
}

#Preview {
    MovieDatabaseView()
}
