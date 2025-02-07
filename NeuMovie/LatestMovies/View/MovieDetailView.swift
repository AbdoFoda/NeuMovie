//
//  MovieDetailView.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

import SwiftUI

struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // Movie Poster with Gradient Overlay
                ZStack(alignment: .bottom) {
                    AsyncImage(url: movie.posterURL) { image in
                        image.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(height: 400)
                    .clipped()
                    
                    // Gradient Overlay
                    LinearGradient(
                        gradient: Gradient(colors: [Color.black.opacity(0.8), Color.clear]),
                        startPoint: .bottom,
                        endPoint: .center
                    )
                    .frame(height: 150)
                }

                // Movie Details
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title.bold())
                        .foregroundColor(.primary)
                    
                    // Rating & Release Date
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text(movie.releaseDate)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(movie.voteAverage, specifier: "%.1f")/10")
                            .foregroundColor(.gray)
                    }
                    .font(.subheadline)

                    Divider()

                    // Movie Overview
                    Text("Overview")
                        .font(.headline)
                    
                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
    }
}

