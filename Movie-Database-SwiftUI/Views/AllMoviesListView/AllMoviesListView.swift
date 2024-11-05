//
//  AllMoviesListView.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 05/11/24.
//

import SwiftUI

struct AllMoviesListView: View {
    @Environment(MovieDatabaseViewModel.self) private var viewModel
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.filteredMovies) { movie in
                    NavigationLink {
                        MovieDetailView(movie: movie)
                    } label: {
                        GroupBox {
                            MovieRow(movie: movie, indentation: 0)
                        }
                    }
                }
            }
        }
        .toolbar(content: {
            Menu {
                filterButton
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }

        })
        .padding()
    }
    
    var filterButton: some View {
        ForEach(FilterOptions.allCases, id: \.self) { option in
            Button {
                viewModel.selectedFilterOption = option
            } label: {
                Text(option.title)
            }
        }
    }
    
}

#Preview {
    AllMoviesListView()
}
