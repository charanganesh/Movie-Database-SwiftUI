/*
import SwiftUI

struct MovieDetailView: View {
    @State var viewModel: MovieDetailViewModel
    
    init(movie: Movie) {
        self._viewModel = State(wrappedValue: MovieDetailViewModel(movie: movie))
    }
    
    var body: some View {
        ScrollView {
            GroupBox {
                VStack(alignment: .leading, spacing: 16) {
                    MovieTitleView(title: viewModel.movie.title)
                    MoviePosterInfoView(movie: viewModel.movie)
                    RatingSelectionView(viewModel: viewModel)
                    MovieCastCrewView(movie: viewModel.movie)
                    MoviePlotView(plot: viewModel.movie.plot)
                }
                .padding()
            }
        }
    }
}

// MARK: - Subviews for MovieDetailView

struct MovieTitleView: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
    }
}

struct MoviePosterInfoView: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: movie.poster)) { image in
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
            .cornerRadius(10)

            Spacer()
            VStack(alignment: .leading, spacing: 16) {
                Text("Released: \(movie.released)")
                Text("Language: \(movie.language)")
                Text("Genre: \(movie.genre)")
            }
            .font(.body)
            .foregroundColor(.primary)
        }
    }
}

struct RatingSelectionView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Rating Source")
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
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.5)))
            }
            
            if let ratingValue = viewModel.selectedRatingValue {
                Text("Rating: \(ratingValue)")
                    .font(.headline)
                    .padding(.top, 4)
            }
        }
    }
}

struct MovieCastCrewView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Cast & Crew").font(.headline)
            Text("Director: \(movie.director)").font(.body)
            Text("Actors: \(movie.actors)").font(.body)
        }
    }
}

struct MoviePlotView: View {
    let plot: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Plot").font(.headline)
            Text(plot).font(.body)
        }
    }
}
*/

/*
struct MovieDatabaseView: View {
    @State private var viewModel = MovieDatabaseViewModel()
    @State private var selectedMovie: Movie? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if viewModel.searchQuery.isEmpty {
                        ForEach(viewModel.categories, id: \.self) { category in
                            CategoryRowView(category: category, viewModel: viewModel) { movie in
                                selectedMovie = movie
                            }
                        }
                    } else {
                        ForEach(viewModel.filteredMovies) { movie in
                            MovieRowView(movie: movie, onSelect: { selectedMovie = movie })
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
    
    private func loadMovies() async {
        do {
            viewModel.movies = try await viewModel.fetchMovies()
        } catch {
            print("Error loading movies: \(error)")
        }
    }
}

// MARK: - Subviews for MovieDatabaseView

struct CategoryRowView: View {
    let category: String
    @ObservedObject var viewModel: MovieDatabaseViewModel
    var onSelect: (Movie) -> Void
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 4) {
                Button(action: {
                    withAnimation {
                        viewModel.toggleSection(category)
                    }
                }) {
                    HStack {
                        Text(category)
                        Spacer()
                        Image(systemName: viewModel.expandedSection == category ? "chevron.down.circle.fill" : "chevron.right.circle.fill")
                    }
                    .padding(.vertical, 5)
                }
                
                if viewModel.expandedSection == category {
                    if category == "All Movies" {
                        ForEach(viewModel.movies) { movie in
                            MovieRowView(movie: movie, onSelect: onSelect)
                        }
                    } else {
                        ExpandableCategoryListView(items: viewModel.uniqueItems(for: category), viewModel: viewModel, onSelect: onSelect)
                    }
                }
            }
        }
    }
}

struct MovieRowView: View {
    let movie: Movie
    var onSelect: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
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
                    Text("\(movie.year) | \(movie.language)").foregroundColor(.secondary)
                }
                Spacer()
            }
        }
    }
}

struct ExpandableCategoryListView: View {
    let items: [String]
    @ObservedObject var viewModel: MovieDatabaseViewModel
    var onSelect: (Movie) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                DisclosureGroup(item) {
                    ForEach(viewModel.moviesForCategory(item: item)) { movie in
                        MovieRowView(movie: movie, onSelect: { onSelect(movie) })
                    }
                }
            }
        }
    }
}
*/
