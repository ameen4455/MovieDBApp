//
//  RatingBadge.swift
//  MovieDBApp
//
//  Created by Ameen Azeez on 22/06/25.
//

import SwiftUI

struct RatingBadge: View {
    let rating: Double

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "star")
                .foregroundColor(Color.primary.opacity(0.7))
                .font(.system(size: 11, weight: .semibold))

            Text(String(format: "%.1f", rating))
                .foregroundColor(Color.primary.opacity(0.7))
                .font(.system(size: 12, weight: .semibold))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.primary.opacity(0.2))
        .cornerRadius(4)
    }
}
