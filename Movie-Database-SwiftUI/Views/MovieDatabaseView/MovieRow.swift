//
//  MovieRow.swift
//  Movie-Database-SwiftUI
//
//  Created by Charan Ganesh on 30/10/24.
//

import SwiftUI

struct MovieRow: View {
    let movie: Movie
    let indentation: CGFloat

    var body: some View {
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
}
