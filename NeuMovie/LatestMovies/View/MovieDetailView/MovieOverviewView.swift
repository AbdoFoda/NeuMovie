//
//  MovieOverviewView.swift
//  NeuMovie
//
//  Created by Abdulrahman Foda on 07.02.25.
//

import SwiftUI

struct MovieOverviewView: View {
    let overview: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Overview")
                .font(.headline)
            
            Text(overview)
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
