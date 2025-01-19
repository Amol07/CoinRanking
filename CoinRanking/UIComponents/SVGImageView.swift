//
//  SVGImageView.swift
//  CoinRanking
//
//  Created by Amol Prakash on 19/01/25.
//

import SDWebImageSwiftUI
import SwiftUI

struct SVGImageView: View {
	let url: URL
    let width: CGFloat
    let height: CGFloat
	let placeholderImage: Image

	init(url: URL,
		 width: CGFloat,
		 height: CGFloat,
		 placeholderImage: Image = Image(systemName: "photo")) {
		self.url = url
		self.width = width
		self.height = height
		self.placeholderImage = placeholderImage
	}

    var body: some View {
        Group {
			WebImage(url: url) { phase in
				switch phase {
				case .empty:
					ProgressView()
						.frame(width: width, height: height)
						.background(Color.gray.opacity(0.2))
						.cornerRadius(8)
				case .success(let image):
					image
						.resizable()
						.scaledToFit()
						.frame(width: width, height: height)
						.cornerRadius(8)
				case .failure(let error):
					placeholderImage
						.resizable()
						.scaledToFit()
						.frame(width: width, height: height)
						.background(Color.gray.opacity(0.2))
						.cornerRadius(8)
						.foregroundColor(.gray)
				}
			}
        }
    }
}
