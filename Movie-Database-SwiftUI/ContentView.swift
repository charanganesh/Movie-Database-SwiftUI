//
//  ContentView.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 27/10/24.
//

import SwiftUI

struct ContentView: View {
    @State var viewModel = MovieDatabaseViewModel()
    var body: some View {
        MovieDatabaseView()
            .environment(viewModel)
            .task {
                await viewModel.loadMovies()
            }
    }
}

#Preview {
    ContentView()
}
