//
//  CategoryRow.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 30/10/24.
//

import SwiftUI

struct CategoryRow: View {
    let category: MovieCategory
    let valuesProvider: (Movie) -> [String]
    @Environment(MovieDatabaseViewModel.self) var viewModel: MovieDatabaseViewModel

    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 4) {
                Button(action: {
                    withAnimation {
                        viewModel.toggleSection(category)
                    }
                }) {
                    HStack {
                        Text(category.title)
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
                    GroupBox {
                        if category == .allMovies {
                            AllMoviesList()
                        } else {
                            ExpandableCategoryList(items: Array(Set(viewModel.movies.flatMap(valuesProvider)).sorted()), filterBy: valuesProvider)
                        }
                    }
                }
            }
        }
    }
}
