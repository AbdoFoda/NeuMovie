//
//  MovieInfoView.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

import SwiftUI

struct MovieInfoView: View {
    let movie: Movie
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
                .font(.title.bold())
                .foregroundColor(.primary)

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
        }
        .padding()
    }
}

