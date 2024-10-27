//
//  MovieDetailView.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 28/10/24.
//

import SwiftUI

struct MovieDetailView: View {
    @State var viewModel: MovieDetailViewModel
    
    init(movie: Movie) {
        self._viewModel = State(wrappedValue: MovieDetailViewModel(movie: movie))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                HStack {
                    AsyncImage(url: URL(string: viewModel.movie.poster)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        Image("movie-poster-placeholder")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                    }
                    .frame(maxHeight: 200)
                    .aspectRatio(2/3, contentMode: .fit)
                    .cornerRadius(10)
                                               
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Released: \(viewModel.movie.released)")
                            .font(.body)
                            .foregroundColor(.primary)
                        Text("Language: \(viewModel.movie.language)")
                            .font(.body)
                            .foregroundColor(.primary)
                        Text("Genre: \(viewModel.movie.genre)")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Select Rating Source:")
                        .font(.headline)
                    
                    Menu {
                        ForEach(viewModel.availableRatings, id: \.source) { rating in
                            Button(rating.source) {
                                viewModel.selectedRatingSource = rating.source
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.selectedRatingSource ?? "Choose Rating")
                                .font(.body)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.secondary)
                        }
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
                    }
                    
                    if let ratingValue = viewModel.selectedRatingValue {
                        Text("Rating: \(ratingValue)")
                            .font(.subheadline)
                            .padding(.top, 4)
                    }
                }
                .padding(.top)


                Text("Cast & Crew")
                    .font(.headline)
                Text("Director: \(viewModel.movie.director)")
                    .font(.body)
                Text("Actors: \(viewModel.movie.actors)")
                    .font(.body)
                
                // Plot
                Text("Plot")
                    .font(.headline)
                Text(viewModel.movie.plot)
                    .font(.body)
                

                
                Spacer()
            }
            .padding()
            .navigationTitle(viewModel.movie.title)
        }
    }
}
