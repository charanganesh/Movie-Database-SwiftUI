//
//  ExpandableCategoryList.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 30/10/24.
//

import SwiftUI

struct ExpandableCategoryList: View {
    let items: [String]
    let filterBy: (Movie) -> [String]
    @Environment(MovieDatabaseViewModel.self) var viewModel: MovieDatabaseViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                DisclosureGroup("\(item)") {
                    ForEach(viewModel.movies.filter { filterBy($0).contains(item) }) { movie in
                        MovieRow(movie: movie, indentation: 20)
                    }
                }
                .tint(.black)
            }
        }
    }
}
