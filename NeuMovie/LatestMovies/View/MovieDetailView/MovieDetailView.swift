//
//  MovieDetailView.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

import SwiftUI

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                MoviePosterView(posterURL: movie.posterURL)
                MovieInfoView(movie: movie)
                MovieOverviewView(overview: movie.overview)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(movie: MovieMockData.sampleMovies.first!)
    }
}
